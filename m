Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515E37CBD3B
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 10:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbjJQISz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 04:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbjJQISy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 04:18:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E5AB
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 01:18:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edTxTHA9erPhs481aBGtMWpYTbkJXO3jYieBaP/7iZsVFVmX6UNej1oaE16vJnTixXZSiGVJoH5GYzwHTOnC9x/wm+36J1u3OkABEUjkV5YI7ID/kn5p27RagFHQB6hzROxEARVqMKlMRBy8xX7hKKmrSKCvUyBpI4pKrf830VZKLQXiI37tP71WlDamVxp4a/tXVXhDFi4BIIlWeDxZTCg9OnGjYhhPk7nOAalICZgypBqWnyM7o1fcZdtcIQH7peGx5cZa9xEGHbmfM2N9NC4BPZxP7Wx/iaVEQKyZkr8qYiDL6OESTdX3DtNCxYYA+GD0Z4Jil/i4O1FkFdq8KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ocqxZQWQOxoZfKS9w4PRUF2my9pVV1DHNNHMlO0d9E=;
 b=mfYlGdI82tgO3+GMzfdH6IswqTFJL3pgFq+wGo3X1+yW4n1z2swHCOVM8+WApr1zrBmZP76Rlo6zP23NrA1ajUvom6aMZyp1h4fSp9UzkF3M7IAJZZbxvp4eaY4XKBh8hVSox8RL3k8/BBqU50phwKvKsn2dTLW8iKwtAhnc/Hb8FeiOu+f9hJz7ytDjZHcRnrMWuUOUedqFjp/kOlJRFCmCCALiWje4JzewRTjF/6ucIwjIT6pW3ZY6jq+cvsNVC4GM4joH7MzPuS+9z983okaoCiD9MnaVtNG9j0RaUWD3FGnWWfNJcch70h4b6AarKtZxlAmJDegZXcEvqEtJgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ocqxZQWQOxoZfKS9w4PRUF2my9pVV1DHNNHMlO0d9E=;
 b=iD+/SZ0coG8da7erXfBGSq1LlCUW4ZlnMNLgpNaPe2gDGF7XmD/k6FSPL4iUa4U6mxP6KwxmT0Rs2AhARebCX+N2dvpsOijBTHuEFALJhQmVgl1PBJvBs+IMTIXLCgB57lx6NEcX4Ei0titweFQJ65agS+U15KjWuo5nbMW1D44=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM3PR12MB9328.namprd12.prod.outlook.com (2603:10b6:0:44::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.36; Tue, 17 Oct 2023 08:18:47 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 08:18:47 +0000
Message-ID: <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
Date:   Tue, 17 Oct 2023 15:18:36 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230923012511.10379-18-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0011.apcprd06.prod.outlook.com
 (2603:1096:4:186::16) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DM3PR12MB9328:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e30ce5d-fd38-426d-1ca6-08dbcee9af8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhR/0HSAnZmn0KGkDcDzlaezUOJgepsDbsBsMHFEmGfa+2gXXdDpIV95LveSukqYQshwTgX2jfwqnaX+0AabSylWNUY7mVWhtsbZIgpybn8Z3NOZ7ki82Pyr5qlcGrTSGAbCFZ+VBbWItBmvpPF86+CeQ3VX8BqGjKK8oc9nkrgLb+WQylC4t1OnysqUL5ziTnsZb5BOmmy5B3oobs0Amd0akXsD+yM3be2/YyIMfKytQCx+k5VhrQ0et0rQsZNWvXUCP64Hys9NUiQ+akqgjyKz0ORmypiktF1FK5KqRZJcud2vUZkCfc+Vrlue0ZMjTIMCjBL7Y1xm9zHUuzVOL4hLvwwTNKzLNC00LHuwyL2cHrm44mm8PGEdVSdvvrU1HhjEoX+NIz5e1xngUVKlhLgdgnUGbGZJ4qyLhHBUmBwmG++zCQIQS1jOO7rw5glUX8Sdr9Ho8N4E2/HhWO6WWYZnINBcf4x31uW585Kg9TZASZBXsX7dMaI+Dw8R/RE5ls7NnZPMUPZ4RdrCb3PteOeIe1Qzo5OjjuMlq8GWCBnMnzEJbKgABvN7TR6Ih+WWeZNkV1mJ4V7i8ZZ8MHfz6i2oX5UuXo4toB4STkRAZObe+N8VA0r3vivPKVJdpMWH8Q3nEt0zVs//wxwUo5ZkUO5dDbTWsNNlCujM3m3HXcY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(376002)(366004)(39860400002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(7416002)(6666004)(2906002)(6506007)(31696002)(6486002)(478600001)(966005)(8936002)(8676002)(4326008)(5660300002)(66476007)(66556008)(66946007)(316002)(54906003)(41300700001)(36756003)(83380400001)(26005)(53546011)(31686004)(38100700002)(6512007)(2616005)(86362001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnRIUlY4MHE3MnZ3bWJqbTlOeWFLbEVYSXk3MzlqZGpjbHdnKzBQTjY3U2F6?=
 =?utf-8?B?UXlwaDVRYzhEV3U0OGdlWSs2TkNhMnBRd3ZMdzg2QTJETmdybVF6SThCME9Z?=
 =?utf-8?B?djNPNlZxOVBRN2ppSEtaV3d5Skl6NnlFc085YjBCeGllaDZBQ2tXemlSTEMw?=
 =?utf-8?B?ODFHOFJZaTcvVmtOMUZRa0lqTUp2dHNyTGJyZ05JU0xoMG91dDg5OUFFMmI2?=
 =?utf-8?B?TS9mM3htcW5QWDVXdkk1MWVXWEEwczZyOG04SVdnclhTUDljcmI1SFNCc21x?=
 =?utf-8?B?SlZWT0VoY1B5enQyYkJ6blIxT0tML0VzOG16RmdaTCtpc0Y1TWk1RFNIOGho?=
 =?utf-8?B?Z3ExelFieS94RzhzYVNxK1hoNm1RanFkRHJqcjNtS2RwNEE2aHdGdVpUaW5F?=
 =?utf-8?B?bllOK3hzZlgzWlNLTExRZGpGWldGUHJmNWlnZHk5U3BrenN3dzZWNUtQMU1s?=
 =?utf-8?B?ekVWaGh5RXU3QjZnbUxtdzQrcVRGZXRsOGZ4bGNtc3A3bkc4WVgwSVcvU25U?=
 =?utf-8?B?bUVjU0lQVCszVnExZFNob2tac21Qd2ZUR3U4TDJuMzJWK3MvQnFzM2o4RlhU?=
 =?utf-8?B?K1Ezc2VVaHg0cjNWSGMvRENLazNFQlpoM1poQUlib1pZZVhialF2OENYMTlJ?=
 =?utf-8?B?KzRNUzRkcld4dWx6czh6WEJkK0hvMFhRa0h4SUtoT1hSc1haUEJld1pNM2ZW?=
 =?utf-8?B?bG54dEpPdk0vMWVNdkU0bDI3UkE3dHllamdGSVJBRVNkS05Ec1lPOFJjajgx?=
 =?utf-8?B?OU9RZGlNMm1VMFhweWkvTENqNzh2TnJ1WnBNQVdOTUR2NzhkbXdUTTd5eHVQ?=
 =?utf-8?B?Y2JCWTlkdUppS2ZQVjI2ekVaa0RLdStuaFM2cmQwWkp6Ni9IZElsNkVYK2cx?=
 =?utf-8?B?TEVTVHhzUGpZblB5c0ZFN3pyOG10UXVQRmwwUi82U0RGT2pkVldWbzY1Ny9q?=
 =?utf-8?B?R1YzK0ZGV09wNjFiWHJpOHR5dGxoUzJzVGRBYUx4bXRiMWdBTnB6VUR3cGd1?=
 =?utf-8?B?Y3I1UFlOM1JyNzMxcTNzZ2FXVG9ycHdEMThBSW5ObkZiQ1lTRzBoRWVUcEFr?=
 =?utf-8?B?SHpwbFR3OGFiZnNMRlJmZE9sZGpJMkJRcWgyV2hEbnVQMTB5SmRlVnZMa21z?=
 =?utf-8?B?Sk52T3pHQy9xaEdhYU1KdGdXSWRPaXBYbHkzNHVSMUQxaS9lQVZxTTlVQnNG?=
 =?utf-8?B?Y0ZjMUNPdzB1Ukpqelg2aWJsQ0xySThDRVB6cTJ4ZUY0V3VnbmVJcUFjejRl?=
 =?utf-8?B?eWxHVHlJYVVlait1cTVwenhKaS80NnovWDBnaHQ3cWtEc2FkSjlqZ1dyRFhV?=
 =?utf-8?B?TEtGc0toNWpyZ1MvUm5pMk95R1JkUEVIY2hBS3EwSk1TcnVJaWRSTklXM1E3?=
 =?utf-8?B?NTJLcC9sTEZGVTVLc2l1MmtvQ2Y4VVlJUTBqZTZzZGFRSFFDNG93VkhGa1lw?=
 =?utf-8?B?YmlGZllLRHlOdkRHbkpNbGxtaWo4K3BHU2wyNVhIaEx2YWM4enlqUG9NNkd0?=
 =?utf-8?B?V2tsb1ZVdm5LVzlCb3pwekYwVnVRdW14M1Q1NGZHTzNMUUFienhXc3hKSnU2?=
 =?utf-8?B?QVBMSFEva3BrWUNVK1RlSksrSDlwdUJ4MVZ1azhzazJmQ1JpbzRUTklPSjdz?=
 =?utf-8?B?R0VpcEdaYktLK2trdnhHWWJlWDBTbEFqd01yaFN3OGFQbmoyeWV2UzZ6NnBk?=
 =?utf-8?B?czdCYzcxTDVFSWpDdWJRYm9Qc2k5WVN3YlBHazJvdUd3MzJsVlRTK0xTc2Fx?=
 =?utf-8?B?c2RMMDljSERMYVRWYlVzMGNhNDVEemlNWjY5YjdhSFU5QWI0ZEtwMDFTcTBk?=
 =?utf-8?B?MTRXMXl3YXRQdVJ2VzcvU2ZtRUhJemZvUCsrUXV6RHhySXdzTGVRTlh5MUNz?=
 =?utf-8?B?dXp6Q3BEbStZZTR5T2s4UXFlaUdDc3FSOCtVWlpOL25PMGVuaVZkbmo5VFY4?=
 =?utf-8?B?Z1JxS3grbklVMFJXTzRDMDhBTExoOFVBQS9kN25wODJjak9YTE1rVjdTbmFu?=
 =?utf-8?B?NHA0cmhhcVhjYVdyaENQdStVcUZvNzUwRFk1VkJXOHgwRHdWODVsRW1vNHgy?=
 =?utf-8?B?VWRZdkxtUFgvS2liUlJBOFZUWkJiNXh5VTlFZVY3VXJQN2l0VVZCVE0vTTMw?=
 =?utf-8?Q?SZ3+W8JqEHdzD+ZHY3Vdk9DFW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e30ce5d-fd38-426d-1ca6-08dbcee9af8a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 08:18:47.4412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FMfxAFTrKL85RMIfLz8hRso7N4vt5WTiTabzpbxz+DAbQVm9t0Xn7G+jLomxuCHAc+aS+0tvYgKRnFNF3DUs5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9328
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joao,

On 9/23/2023 8:25 AM, Joao Martins wrote:
> ...
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index 2892aa1b4dc1..099ccb04f52f 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -486,6 +486,89 @@ static phys_addr_t iommu_v1_iova_to_phys(struct io_pgtable_ops *ops, unsigned lo
>   	return (__pte & ~offset_mask) | (iova & offset_mask);
>   }
>   
> +static bool pte_test_dirty(u64 *ptep, unsigned long size)
> +{
> +	bool dirty = false;
> +	int i, count;
> +
> +	/*
> +	 * 2.2.3.2 Host Dirty Support
> +	 * When a non-default page size is used , software must OR the
> +	 * Dirty bits in all of the replicated host PTEs used to map
> +	 * the page. The IOMMU does not guarantee the Dirty bits are
> +	 * set in all of the replicated PTEs. Any portion of the page
> +	 * may have been written even if the Dirty bit is set in only
> +	 * one of the replicated PTEs.
> +	 */
> +	count = PAGE_SIZE_PTE_COUNT(size);
> +	for (i = 0; i < count; i++) {
> +		if (test_bit(IOMMU_PTE_HD_BIT, (unsigned long *) &ptep[i])) {
> +			dirty = true;
> +			break;
> +		}
> +	}
> +
> +	return dirty;
> +}
> +
> +static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size)
> +{
> +	bool dirty = false;
> +	int i, count;
> +
> +	/*
> +	 * 2.2.3.2 Host Dirty Support
> +	 * When a non-default page size is used , software must OR the
> +	 * Dirty bits in all of the replicated host PTEs used to map
> +	 * the page. The IOMMU does not guarantee the Dirty bits are
> +	 * set in all of the replicated PTEs. Any portion of the page
> +	 * may have been written even if the Dirty bit is set in only
> +	 * one of the replicated PTEs.
> +	 */
> +	count = PAGE_SIZE_PTE_COUNT(size);
> +	for (i = 0; i < count; i++)
> +		if (test_and_clear_bit(IOMMU_PTE_HD_BIT,
> +					(unsigned long *) &ptep[i]))
> +			dirty = true;
> +
> +	return dirty;
> +}

Can we consolidate the two functions above where we can pass the flag 
and check if IOMMU_DIRTY_NO_CLEAR is set?

> +
> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
> +					 unsigned long iova, size_t size,
> +					 unsigned long flags,
> +					 struct iommu_dirty_bitmap *dirty)
> +{
> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
> +	unsigned long end = iova + size - 1;
> +
> +	do {
> +		unsigned long pgsize = 0;
> +		u64 *ptep, pte;
> +
> +		ptep = fetch_pte(pgtable, iova, &pgsize);
> +		if (ptep)
> +			pte = READ_ONCE(*ptep);
> +		if (!ptep || !IOMMU_PTE_PRESENT(pte)) {
> +			pgsize = pgsize ?: PTE_LEVEL_PAGE_SIZE(0);
> +			iova += pgsize;
> +			continue;
> +		}
> +
> +		/*
> +		 * Mark the whole IOVA range as dirty even if only one of
> +		 * the replicated PTEs were marked dirty.
> +		 */
> +		if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
> +				pte_test_dirty(ptep, pgsize)) ||
> +		    pte_test_and_clear_dirty(ptep, pgsize))
> +			iommu_dirty_bitmap_record(dirty, iova, pgsize);
> +		iova += pgsize;
> +	} while (iova < end);
> +
> +	return 0;
> +}
> +
>   /*
>    * ----------------------------------------------------
>    */
> @@ -527,6 +610,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
>   	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
>   	pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
>   	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
> +	pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
>   
>   	return &pgtable->iop;
>   }
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index af36c627022f..31b333cc6fe1 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> ....
> @@ -2156,11 +2160,17 @@ static inline u64 dma_max_address(void)
>   	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
>   }
>   
> +static bool amd_iommu_hd_support(struct amd_iommu *iommu)
> +{
> +	return iommu && (iommu->features & FEATURE_HDSUP);
> +}
> +

You can use the newly introduced check_feature(u64 mask) to check the HD 
support.

(See 
https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/?h=next&id=7b7563a93437ef945c829538da28f0095f1603ec)

> ...
> @@ -2252,6 +2268,9 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
>   		return 0;
>   
>   	dev_data->defer_attach = false;
> +	if (dom->dirty_ops && iommu &&
> +	    !(iommu->features & FEATURE_HDSUP))

	if (dom->dirty_ops && !check_feature(FEATURE_HDSUP))

> +		return -EINVAL;
>   
>   	if (dev_data->domain)
>   		detach_device(dev);
> @@ -2371,6 +2390,11 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
>   		return true;
>   	case IOMMU_CAP_DEFERRED_FLUSH:
>   		return true;
> +	case IOMMU_CAP_DIRTY: {
> +		struct amd_iommu *iommu = rlookup_amd_iommu(dev);
> +
> +		return amd_iommu_hd_support(iommu);

		return check_feature(FEATURE_HDSUP);

Thanks,
Suravee
