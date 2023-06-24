Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D0373C64B
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 04:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjFXCJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 22:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjFXCJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 22:09:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37AE1BD0;
        Fri, 23 Jun 2023 19:08:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htvxflqXvLwaxvuytKITgShCWXz5pcwrbrh/dM8qrpkeWvVRhKPcw3eOVtXiO5LvVVvB7PiOUv/e1rMJZ6yx9yuhKdvQYng5jAsMjsivHNj/0zq8+n71vKl226HrQyrPtoBpmcABHxmOfBsf/rnF7OF51t/tNz9IRdkNd/REf3hHDTSnsxpJmC13lFrWtiB9wWnUMk8jrmLGN8mtfwL+FJax995xnBB1cGwULn4yYAWU+u2yxOtqA9ZQVvKas1/MVtQqO80YYaIfWTOFtJlN8nJ00xULirz4f5mRI+gJi2jbrSY08aC5mR6cFIwi8aLP2FvDHuEj+HVPj5ibkDG8hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwQu8yNOeZ8Axb1e+ou4FfQxYE4uYmQbzQeNORhY/o0=;
 b=BuzVpqTa3818oSAagvZEmCtEIKXE9qfxMD+495uAdsP9R39BVB1h2ACpe+GeNXMjCNL7uD5WJTXgJ4mfDDapN9UXjeaXaW8kcl+z3/g3V5yVKdW9GcqIVHuuNQ2jqN3kcpux00iql698a22ZMXTFyBylCDwkxm+oFVEHm1OopQT0sFQcJlDlIdchbP68yNyuizEn7C6DaeJtSDzICB5Kd8sEbO8TL9pz4YDi9SSYjxNr7tGfk5tq9WrPrNnCHamhmy77//FrHrG51NkgdMZ7QZypsdaoX80f7vk3qbEglz8C4kVN8FMTSilcXqXIwdzwDq5XBGFMJxLehHYggRa6oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwQu8yNOeZ8Axb1e+ou4FfQxYE4uYmQbzQeNORhY/o0=;
 b=QH9BSYjF4q5c+oaT2K+/5h7CjSFTuTp3XsXZNh0qen9Aodc3cqOB163UDWIpZzEJ5DUoIae/oxFpVZXUhRiIYHcor/PFM/wZr3OdtEseJgdtYif3V79kpX3S/xsiXF+iPuUGBTHKLJQk+Kn4EGaN9pvpjNkAPt4F7CiGOt2uFLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.23; Sat, 24 Jun 2023 02:08:57 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::1f96:31ad:7de0:2175]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::1f96:31ad:7de0:2175%5]) with mapi id 15.20.6521.023; Sat, 24 Jun 2023
 02:08:57 +0000
Message-ID: <ac4570c8-609b-03c3-c320-3dbe7432a8ed@amd.com>
Date:   Fri, 23 Jun 2023 19:08:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [RFC PATCH 00/21] iommu/amd: Introduce support for HW accelerated
 vIOMMU w/ nested page table
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, joro@8bytes.org, robin.murphy@arm.com,
        yi.l.liu@intel.com, alex.williamson@redhat.com,
        nicolinc@nvidia.com, baolu.lu@linux.intel.com,
        eric.auger@redhat.com, pandoh@google.com, kumaranand@google.com,
        jon.grimm@amd.com, santosh.shukla@amd.com, vasant.hegde@amd.com,
        jay.chen@amd.com, joseph.chung@amd.com
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
 <ZJRQseaYkTJGHNsk@nvidia.com> <7364628b-54b6-b7e3-b272-8f91198679f9@amd.com>
 <ZJWF3oVvdj4OQmTf@nvidia.com> <b3c85550-a7f6-a0d9-74a4-f98c8251b80e@amd.com>
 <ZJYjOor3TKSeIo7F@nvidia.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <ZJYjOor3TKSeIo7F@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::26) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DM8PR12MB5416:EE_
X-MS-Office365-Filtering-Correlation-Id: 54551e0e-d22e-4b52-0b15-08db7457f801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfCZ6dMVlgoPWL/9ZM0AIv56LYhnwweo04z9MVI+N6OvVbiJd6C4+GsIobZifqZd4IelYx+r1NptHwX22SfjuE09S37nQK3TYg4b+T+CRL2Cmp02GdKLWw1l+DqKTMMGcP8kQWpltKGlbHhMoJN5fk0MP8xeSYfj+pNxUZNo1PY4X+hzO2ihFFDIGjxN40cLfdaiTBVXfdzdR4sNi5qk2bWNutq22EJuyza9wFtX/skzswcTmonPPe8BQAUKMzimQj3qoBia202+jOqIeSr8Y+Vq29j5tIQCzyD2NVT3X2qbD0hPK9lmqEHftZDrtwrv7eHTSwJ5vrLUDDMBKE1wiRnZvODy52JSxXGDlQJVRikzi2GpCmO9aQEJq9PD8T9VXsTmdtwqFGOESJoy0/6c5TCp+lpxUFhNAGAZp7XUv9Pi2+aOfRaD7QKAdEZ6az5zo9kL6XbvjlCuwemLlQlg8cOjp1sWOnuIXSzsgQClnXko+20dzViN5WQSEWytOtJ+zTLjeGzgmFbV4li9BNrv/GKhGV5qUhWs9hENxoAYUhuv6wVp61mVJBN7CPfwKpJSxVa9E8+zcgeWdrL3j398KNreY+kNxjPbx9eFvy7uYAeArUF4YBN/iX16HIOwKNCTtyPkN73uM08JE7JM4pDaCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199021)(31686004)(6486002)(53546011)(478600001)(6666004)(38100700002)(2616005)(86362001)(36756003)(83380400001)(66946007)(2906002)(31696002)(966005)(186003)(6512007)(26005)(6506007)(4326008)(41300700001)(66476007)(8676002)(8936002)(5660300002)(316002)(66556008)(7416002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEQ4SVRaWXJ2OVJBNUNjNjY1dWo4ZzBLM2VjZmxoSDhWbVhxaWlSc25Ca29l?=
 =?utf-8?B?VndKc21vZkVTMWVpSzRsUDFBTTQ5N0M3T0hYZldoNHdlcG94U0FuTUpNVlNp?=
 =?utf-8?B?dVpWL0Q5R2p6T1RnWVkyeE5xZU5uUkFJWGgvTU5lTUJOYkk2WDNTOG5XbURW?=
 =?utf-8?B?cVlFeUZuMEdPQXJxRFN2dC9laGdYWlNUWEhlbGh6U0NJQXVDbmNmejZPbmZs?=
 =?utf-8?B?Sm5DdTRVZTd4Tk50eFlSSEVTa0xlVUNUaU12TTRSR0JZcWRVcVd4NVFBblFO?=
 =?utf-8?B?NzlualFyb004R1d6N0pkUkg5UmhmeGoyb3c3Tk9GQjZ6a2NvNlVPSGN0dHV3?=
 =?utf-8?B?dXdCKzMxZ2JBOCtKK3hQMkNGeWZoT0RsZTRCZE9XRk9kR29OOTNCbGJTdkVG?=
 =?utf-8?B?OEFYTTRnZ3RzaW1RZHl5OGZuUU9NWkJyWnAzSTF1eE1YeTRqUDJhbFJ1c2VJ?=
 =?utf-8?B?S1ZyaVFQb3Z6OStPck9VL2VHSVcvUllrUTNzNGFDNFU0RHU1eHFtbUZlOFkr?=
 =?utf-8?B?TVpGa1JXMG1hcE1kMktlZUx3S1p3eWJnNFg2WFp1UFpLajgrZGkwOTRwVnZU?=
 =?utf-8?B?eUR6V2ZYbzNsM0RvVmhKNkRRczhqRmdDM0NPYWtDM1ZySmNlcUo0a2RDcGt2?=
 =?utf-8?B?L2NYNFdycE5Nd0h5bWdyMGc0M0NRY2dmYXo4eHlwYlo4VTQwRUxWYTNUWHYw?=
 =?utf-8?B?akJ3T1RoZDhZb3dIR0pEM1dETExDOWJZRXRYNWk5QWI2SGVtRXcrbi9CYkFJ?=
 =?utf-8?B?ZFJVMjJ6QWtCOWJFQklXQVhlMWVxemt1L0EycEhpbFgvVGZOVENDK3B0dWov?=
 =?utf-8?B?M2txV1RKU3BoaSthWDZmR3MrRCtEVFlMUm9iOE9uY1RDcDJGZ2xRU2I0RGtN?=
 =?utf-8?B?Mk5ZdHNjWnZ5aERwd3BLSlNkMWV1SktFYkYwWU1MWTZFSzFuY2FhanFuemVJ?=
 =?utf-8?B?OTRrN3hqMCsxcEZ2NjliWXhoYWU5WktaZWVVSVlrbmVldDI1bklKT2xyelNa?=
 =?utf-8?B?T1NNTjNqV0lTRU5sZ2N6bkJLUmRxVm9zckRkU0JuM2dRZzYvb3dESmIwelpI?=
 =?utf-8?B?Vy9FQllMTFprcERTeVY5cTllTTAwNHJ5NWJQM1dHTCsvQ3I1K3o5ZTBCL3A4?=
 =?utf-8?B?TFFWL3ZPVUNBYTgvOEVNM2l3cnhhQ1JRWXhVR1k1MXFocFZ6R1hhSjdqS3VU?=
 =?utf-8?B?RmVQUFB0cUtKQTgwcmV0U1YyTTU3M045S1lBWjRGK1g4Y3I1bmZsR0IxNndO?=
 =?utf-8?B?UlV3Q21KSGhka0FJYjdJdllJY2YwK2JVNW9DUk44aTFhRXNnZmNhSkx0MnFG?=
 =?utf-8?B?YW9IS280SkNtVENNRDlqS3VvSkhaQkdDUDN0VGdEWkkvREgyVzhIWWJhTDNp?=
 =?utf-8?B?YUlLYUsvSXJCcXhJTkFqUXRURTAxcmtNNVJ1QzBrNkhkUmk4VlBqTkYvQ1JT?=
 =?utf-8?B?WmYxbUU3R2JsWTJaREdYbHI0aTA0NXUrWFN6U3hUSGVqMEQ3c2hDVnFxRGs1?=
 =?utf-8?B?Nm1UWklXYzlCRk1YMnBSaC9BaEpsRzkrMm1sUkdQSnZwaVAyLzRhUmpPS2Z0?=
 =?utf-8?B?UDNEYVBzbDlkWXprZk5wWEptcjBvam00TUR1bFl1K0ZKOFFvbFZWREh5VkNt?=
 =?utf-8?B?NHZvbDRMbjk3ZVJaNUsvSUZCWjRZTVVHbm9PNVd0OE9nL1U4eFNYYmoyaGE3?=
 =?utf-8?B?UGdpYTlXWEtxSlNhMjFMVmdyN0VEWjlsQnlhU0pNU3RGK1RON2Z4b3hZRUxy?=
 =?utf-8?B?MXhPeGhqTVNzVElyQkNEbnpManNOanFYYWNTQXN5RVZDYXdsb0tWMTVYcVZ1?=
 =?utf-8?B?N0lnUFJUY2RRM3NrYkNWcG9LQXAxclVYTlZxd2t5THZZcDR0Zk9BcGp3R2dy?=
 =?utf-8?B?QmNhajl4d1ZOYnM5Q2J4RjE0Z09COXg1M0J6RTdobk0xdmZUcTUwN1UwNWpv?=
 =?utf-8?B?WDFKSTNXSHRaMlc1NzZJWkMvQ3RxVGtyMHpWeFF3MXhVaDBZMFM5NWRpVVpp?=
 =?utf-8?B?Q0RTRmJtQStpMDdUV2NuUUpYQ0k1ZEFJWmUxNWRmRkpOSHFZRFBFTUVIS05m?=
 =?utf-8?B?RTNKWTBkZXI5bndNc1RpRVVZcXl5S3A5d0cwSHg3cVhBTG1uTGVaZjUweE5S?=
 =?utf-8?Q?C4Eka33BAgNA8qECz1BUvIyQY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54551e0e-d22e-4b52-0b15-08db7457f801
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2023 02:08:57.7237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 836iaHdH2Yc3i+JAOQ3UkZKWEySXwTWxD+2ClJthIvzpA3SK2Ca4DbHW1Z/31IvL+G0NmTMULzVpju76hePnCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5416
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/23/2023 3:56 PM, Jason Gunthorpe wrote:
> On Fri, Jun 23, 2023 at 03:05:06PM -0700, Suthikulpanit, Suravee wrote:
> 
>> For example, an AMD IOMMU hardware is normally listed as a PCI device (e.g.
>> PCI ID 00:00.2). To setup IOMMU PAS for this IOMMU instance, the IOMMU
>> driver allocate an IOMMU v1 page table for this device, which contains PAS
>> mapping.
> 
> So it is just system dram?

Yes, this is no different than the IOMMU page table for a particular 
device, contain mapping from IOMMU Private Address (IPA) to SPA. The IPA 
is defined in the IOMMU spec. Please see Figure 79 and 80 of this 
documentation for IPA mapping used by the hardware.

https://www.amd.com/system/files/TechDocs/48882_3.07_PUB.pdf

>> The IOMMU hardware use the PAS for storing Guest IOMMU information such as
>> Guest MMIOs, DevID Mapping Table, DomID Mapping Table, and Guest
>> Command/Event/PPR logs.
> 
> Why does it have to be in kernel memory?
> 
> Why not store the whole thing in user mapped memory and have the VMM
> manipulate it directly?

The Guest MMIO, CmdBuf Dirty Status, are allocated per IOMMU instance. 
So, these data structure cannot be allocated by VMM. In this case, the 
IOMMUFD_CMD_MMIO_ACCESS might still be needed.

The DomID and DevID mapping tables are allocated per-VM:
   * DomID Mapping Table (512 KB contiguous memory)
   * DevID Mapping Table (1 MB contiguous memory)

Let's say we can use IOMMU_SET_DEV_DATA to communicate the memory 
address of Dom/DevID Mapping tables to IOMMU driver to pin and map in 
the PAS IOMMU page table. Then, this might work. Does that go along the 
line of what you are thinking (mainly to try to avoid introducing 
additional ioctl)?

By the way, I think I can try getting rid of the 
IOMMUFD_CMD_CMDBUF_UPDATE. Lemme do that in next RFC.

Thanks,
Suravee
