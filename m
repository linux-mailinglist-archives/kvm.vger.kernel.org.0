Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061862B6A5F
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 17:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgKQQem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 11:34:42 -0500
Received: from mail-dm6nam08on2042.outbound.protection.outlook.com ([40.107.102.42]:15415
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727388AbgKQQem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 11:34:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0qd5pQmt+BDhAPU6SN/3auFQ3zX/5TvOnmPnaTXypoHxs7MJgw2VrsbuV4oCydaVsVHcKTdD4j/EolaS/mwbZOUWOUTg4OMP3DDOpW76YJAuqcc1FJdc+aqjlFKzSqe7+Fa/AfT/lXwiDzmxDlo1lie/edAo79KZA+zLc2NvsuKHAyUlxZGugjDUWk5GTvtMOIz+ecbz2o1k3RyaeryoeNjc9kcnewYeakYrwNJzMbT0ZHTMVtsCPmQgMpVick+NlV/wFZAx0Yt8OXTrb2QKvpoudl7/XyKUOqVWL25h4K4mAiFLoV49TLaF43DSZUnPn/B68PDMiAtP1w3JXiMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8cV0RS8in4e52ifnNFK9jgYpm7K/8F8Eew1bzvIysk=;
 b=aCpUxpui+sztOSwBPJKv9+82HkHIL6jYVZtLlZDztnG3DnP7A63BVnwSXd45iMNUb/mGlLCMlO4kXXUXb74ss9OIcH05CzPBw1Ahc4ZjUgK0pm8GOddzNqE0+ETbn8uZcsvgmV0WctOZJnQHpg0ja4jES25PyxLzvGz2u3y+68GwGDT60PLYs6Tin/JxOLHhFnCCMjM1EZfNP3mMzRj8PnVtFf2GjaFWixbPkc41Z93jx2tF9j846KCZCPTg1MjXlJniTOL8MasU8DKVmRrs5OfCvJcs7u15dWw4Sn7DIo9G5ndnBRwcXLZTwjDFNiAvRxWjrWrIEZ03fw2RjUW6Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8cV0RS8in4e52ifnNFK9jgYpm7K/8F8Eew1bzvIysk=;
 b=AlKRJ84qDd95C0p2ObY0iGR9P6eDAoXvR3cL/KgdW/jxfOTKbZPhrrX/c1R3XTSmL/2BNPfik4JXEHaLzIXPlvyXVsbw0dARVjUYjhcKRout6wM6IJfgRVNd0Myn02WhRWnn7YquIRpdSij9A6gzGc40BQCmsYcxII501XDTzyM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.28; Tue, 17 Nov 2020 16:34:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 16:34:39 +0000
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
To:     Peter Xu <peterx@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
 <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com> <20201117155757.GA13873@xz-x1>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <57f51f08-1dec-e3d6-b636-71c8a00142fb@amd.com>
Date:   Tue, 17 Nov 2020 10:34:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201117155757.GA13873@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0019.namprd02.prod.outlook.com
 (2603:10b6:803:2b::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN4PR0201CA0019.namprd02.prod.outlook.com (2603:10b6:803:2b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 16:34:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 472e3897-7b85-4816-5d00-08d88b16adb9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4484:
X-Microsoft-Antispam-PRVS: <DM6PR12MB448483BDA3F8947944B8A264ECE20@DM6PR12MB4484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z8T/QfieqqfPqefBo1x7DOJqkS9OMAFMlRHdw3P6ngPu44gXGPu9rQmmOKCLGydPYTYmULd6XAR9GZ5BojDjavKmXku/1p3K0SEVQSW8N1KZVvGf5W0lpo7wcLx6EPssy6HpkH+VCSJw2px2bG4T1Ym4d1UcVuZObI36pKTpjQQ7eHxYs9gneh40DWJ5K2bnwhVcrccTam56vMko3lkXAv9FPOojzU5tZugr0lpPvTCWArvRVmlQOtxgumO8NTFpHcpH2bAjCK9bHzkAcfLy21OGQHqGCaYybWLuTkWJhvj7n1ugPr9ifP73HB8nPm0h0EPzoppAL3Nr11zWoT4VR+sHjdM/bOSfrzYUmiQTG4SP1hh662MlJmEhVnE9LW0L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(83380400001)(6916009)(36756003)(52116002)(54906003)(2616005)(316002)(16576012)(53546011)(6486002)(31686004)(5660300002)(31696002)(66946007)(186003)(16526019)(8936002)(478600001)(66556008)(86362001)(8676002)(2906002)(4326008)(956004)(26005)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BIw4ddFziropDSuRq4O+QIgGZ8q3eHNTkULO5rO0CG7zcIL3Apeadm8XV1nAUpx9P00VBq+jMGnRHff0zYKT25UBOZZPPHAhVeU66NOY3ikPq2/fcfWeY1eSdiU+1pCmJq7/mqYyQVsyCvKPoHeF9wWKPBLF1bkfF8Xf3RoXnBM72YLTZsZXRZzF2vTeqPaeUcGZoaVgsYXhpKhs5SFPszGvFcHiuGfiPlv6Y+/fvn+4G5yQefNF1DkM1HsEbPCNN2L6XYwD59p5CIryw9d6bn57Y+ImPk022AksCwOkTborBY9PEVy7TBEOgB7qecRfaGjuLGAMKKDBDjuzacXIfH25q8yvKXWtaIUDouLs0ZMaLpjsSNJjv33F0FyRc8xNHuMa1h10FLLVC8nJyb0W+ea9r9EwsGZAWhlmTQxAMp2cQkhUAjEnlhMkd/XnJ0VdVaibn2bFGKlJHr4ixRudxuARGaNl1anDU9IMT3jNl0eqzIg03DCLQJ7aY/8kAgcnYeLCShVUfXAgzpS04tz5qImQ7y61AHJEYVYP5P00/xztkDpmcOnEnXcB8QbKyFC3DF8RqSh4Ql2JcBfSTqQV0rd4DizKh5rQcmzq8RhfEo4q4iuFE1JOCoTUo7HYv7POzGZiTA7m1lVyV6m6uqvtXg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472e3897-7b85-4816-5d00-08d88b16adb9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 16:34:39.7940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZtp8P5tDKmdAWg/tP+PQF14Pb0IaqI5UoFUCwrP3fbZ9SOR0kqZu4SWgocmZnABtwYE8yY4jifC1/IO/6FBxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/20 9:57 AM, Peter Xu wrote:
> On Tue, Nov 17, 2020 at 09:33:17AM -0600, Tom Lendacky wrote:
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
> Thanks for the explanations.
> 
> It seems fine if two dimentional page table is used in kvm, as long as the 1st
> level guest page table is handled the same way as in the host.
> 
> I'm thinking what if shadow page table is used - IIUC here the vfio mmio region
> will be the same as normal guest RAM from kvm memslot pov, however if the mmio
> region is not encrypted, does it also mean that the whole guest RAM is not
> encrypted too?  It's a pure question because I feel like these are two layers
> of security (host as the 1st, guest as the 2nd), maybe here we're only talking
> about host security rather than the guests, then it looks fine too.

SEV is only supported with NPT (TDP).

Thanks,
Tom

> 
