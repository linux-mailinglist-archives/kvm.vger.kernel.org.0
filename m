Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D54D36873A
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 21:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbhDVTfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 15:35:13 -0400
Received: from mail-co1nam11on2058.outbound.protection.outlook.com ([40.107.220.58]:59809
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236668AbhDVTfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 15:35:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGM6SEpiz4hN0FVdETT9MUJYygtfTY+X6OvTEfEXhFARCZl4Q5jWPjGLC3Ur/u9YK3JfK3vF0sJZAmW9h5RAx8OksKQngbm1Keg9uK4CaxsaG6WOL1PllNpSzwVS9l0piDVwUMpBJTziHnc3HmdnZG4fcMVUSuI1rw4lh0obfvFbQIYqcT1niu5CDaiMp48ke6wDXSVInv5XH8yQLKeE/Gqhu7ZhO4+tS6p7nYIPYPITLEJOliexY2bV0vGM1fQXdxD34LXGZ+rkMHcWYRiOJUHgo2loA3ERV9+nppvaxCTyWNiya7CXrjej/7E2L7b0qtKJMUbFyovkvKg9hTW++Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSDOcJXeuGnlWb056i+4PRjeQsu0V6uJu7zxVfEMksY=;
 b=Cn1WArvgEh0eMCzEakejLWHNiN222wmlCNJ0BkqJ6RMaOmXfGdMu49K3Xky/o9vLW1FQZIBAGA2Tfcix7Z/oKyauQ7LPZC8Bxjyab1udv2ez+Em2zIJY+S1s/e3AjUM8BUY0n/zS08Z/F8RJPBtqoV3R9lJkDfT6TjoKnmgKG8Ba8cZ6X7jp9U7l3rlBwSwjUPP+pyQ/t3gKgTbgLF+YaUG5MdCrbiv+fnhAlOgZV0zHtc04d8YF1THFKpS3HWSxkrgWNvENJXeWUxAjVUIONU2KfDZPTpyZOrmhS4f5tOLm2qYsZTVdBDt9GhiWJfJOyYkY9DF0g1x4baG/kSwEtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSDOcJXeuGnlWb056i+4PRjeQsu0V6uJu7zxVfEMksY=;
 b=W7u1dOfpFOLpXTGk8NGxW3LTRXObJJ/m5xn6qLsQ9QxjK9BVxmanferDKn/WYE5dM8O3aHXVh+D1y1lbYQHeauDonnlO4rsY/q17YnulBGqh/cOLJP8gBpvkNTq6uVTIw1aeQeYBA1gD9IppQADUGp7eFQpSS2MIP7co+vQ70X4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1867.namprd12.prod.outlook.com (2603:10b6:3:10d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.20; Thu, 22 Apr 2021 19:34:35 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4065.023; Thu, 22 Apr
 2021 19:34:35 +0000
Subject: Re: [PATCH v5 02/15] KVM: SVM: Free sev_asid_bitmap during init if
 SEV setup fails
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210422021125.3417167-1-seanjc@google.com>
 <20210422021125.3417167-3-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <1f3f3ccf-a6af-3ea4-3109-5d38897f820e@amd.com>
Date:   Thu, 22 Apr 2021 14:34:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210422021125.3417167-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:806:6f::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 19:34:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b26c58cd-66b5-4397-4bd5-08d905c5a91a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1867:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1867F166B8ADE87AD26320D8EC469@DM5PR12MB1867.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BTCpNxzFOpPoF3W+gmxvQEP9TW1NQ8pYskiGaCtoqaRwtY7vi/9F+Y8nFR7cEhM8+RUsIeWMnizgPRb4AewSogOIJBv+Yf2U2oB/eRMbj5OiQ1p34gmnJdAmwHAVM5wyCQKiTI/gG/B6Nv2ZPW5GEOcebZ3A3+wKRWcJDzXKWdEY/CYH5fhZ830N30u4KYUuEu6rEmnzF+QkIxJa6v1jz9wMoiliDiusjctnSrWCqrYEeHBsOoZLvJBKzC3NBrIQjjfA9Nhk6vZlAyQdDVDgwBAqru+D4xK7c+cnrDD8P+JlVol2Tm177sqtr6tF+pnd3A00AC69eRryvA3cavSLSXVOBrwRmP0M5fkM9F382Kx3vmXS9Z1Flndy/Yc9mAOkXM9YGfPLJL5nRq7XiplkVtHnS7CXFNtF4bWAXln9a0EoH8/6N7amvEsNfSe+RcCkzCsOXiVjAsQVTXCUTckxNxwXeGJF8wAaypU+Fhmf9E7LNbileh+FNsvAVva//7Dzt/k7INUVOXEabNEkAX+7VS7CSNJtNY9GTU/LtPEluDvIAtI7YswnU4NPwGJ0HARAsg6+2tovUQwysXM0UOXM18kx8YIFYkZofd0iJg72AkZ1y0HVIMtwGrWVO7zXL4tLwpjd+ylQEkMpdRPeZgU7LIkuwPYMfWoq7SxYH4RD8r8BNGJkS3dHNvqQQdlY8mqJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(83380400001)(38100700002)(2906002)(31686004)(16576012)(66946007)(66476007)(8936002)(7416002)(86362001)(66556008)(186003)(26005)(316002)(54906003)(4326008)(478600001)(6486002)(110136005)(31696002)(16526019)(8676002)(956004)(53546011)(2616005)(36756003)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bmZ6aUxJMGVSSlZrS0pXNW51MmYyOU03b3lkeG5FaHZ2Vmt4WGl3anN3NnlF?=
 =?utf-8?B?U3JXcENxWUtrTVBpdndTOCswdGNLYWdOS00ya3FyQ0U3T0dhbExUaHFXNWlX?=
 =?utf-8?B?bU1rNmNaQTl3K2Z6STBoUWNKQmdYN3dlWFhIdmg3TWw3dkY2TmY4QmlrTWJS?=
 =?utf-8?B?T0U0ZUd6ZGJ0Qy9KdVpjK0pSY2JJNHZnNmJyQ2o2RCtHME5zNjE1VDQzSE1p?=
 =?utf-8?B?VlBCaFNaWCtHWTNKTVUwV1RneHhTRy9POGxERSt3T3FFWFljdDQ1Q1Z2RXVr?=
 =?utf-8?B?MGFSLzhYTk1CeHVsMzVQaGhjMHhVa3ZSZEhtZlZuaTAyY29VQnRCdzRIRTFY?=
 =?utf-8?B?Mzc4RnZmZ3pGNEFVUTIrQ0tCMi9tTVd6cWtPa0hIaDh1UTUwbkVoVTd2R0kv?=
 =?utf-8?B?N1VGR3J6V001M21mTW1LaWkzdmpuTXBUZmtJY3VlUXhrVEo1eUFQYnUyK2R3?=
 =?utf-8?B?SVNNMytLYUVVTkphbG1mZUxNRjlERlRyMDJhSUYycS9qWGJzV0Rrb1ZhQVF3?=
 =?utf-8?B?L1JoeE1wTGFyTWdhUTY3SWRFdDdqRnN4NFZRNXJQZWRpeW1jR1Z6U2JDR2l5?=
 =?utf-8?B?T1BHTURyZStVeDBZRitNV1FvNExBamltS1Q1NXpQdUlWT0JyZ1VWMHpsclNT?=
 =?utf-8?B?Z0pVdWdQM0k0VUxvK1p3VHRXMC9aT2NDTDhzM2ZHYnVXclFWcm9GMENJZWhl?=
 =?utf-8?B?TFJXai9JL2RmcnI4RmJmNFpmNzhLWjFlZm5KaVBzdnBKVE1ON3lkRHUzcWkw?=
 =?utf-8?B?Uy9FYWNVdUZ2SDJlaDAzdVdUVGVDRi9XZEdXMjBEaFlNZURLZlBUWHJ2NW9I?=
 =?utf-8?B?U3Z5YTdGUW10enorc0RCZDl0OFJMbWtlVVZHZ2VOc1FHWHYrS25KVHM4SExY?=
 =?utf-8?B?ZEtId0pzNm5YOXRYdWJhOEJnbWw4c1k1OEFWamlEL2k2S01GbC80OEZSeG81?=
 =?utf-8?B?ZE44MnU2OHl1Z0EycDRMRHBRaHgwU0YwTUZDNjFIZmVIUFh4UEpqVXRlajB0?=
 =?utf-8?B?UEJZMmV1eXVsVExiV0R2YnJ1V1pwS05IYXVncEV4YzhraStiQ3lhU25GVHI0?=
 =?utf-8?B?SXFkRnBHRjF5ek0yWGlPM3pNUFB5aWYvQ09QVGcwOGpSSnpjZWRiRkh6bnd5?=
 =?utf-8?B?TXN4TU40VXRqa3pjSThNaWNWdVVxZGdPYzJ5eVF0cnZPN2VhL0hveHFWNWFr?=
 =?utf-8?B?bkVzL2JEbmpaNWtWTTI4MndOWTBJOXBpdnZIVVRtSWdGNkNhNUtjSnFtRmJ2?=
 =?utf-8?B?KzlMZng2SGJBMzByYUNtYkhpd2RycTU5QzF1YUxFZ1RBajhGMWQrdWkvSENM?=
 =?utf-8?B?MlFtZ0Q1RmdzNC8xSnpPMXpyRWc5V3l5cGl0cG1lN0tFUHlPdk1OUDZha1dy?=
 =?utf-8?B?QVBNVzZCUkpscDRKYWx4NWhmSFpITGJEMHArME5MWkk1c0IvdUY2OHpXVFJk?=
 =?utf-8?B?WVNwRi9oNGU4L0VEMmxJYUVlbG51NGdvTWMrZENmR0w0UzVSMlRZTVdidEFL?=
 =?utf-8?B?Z3IrRm12OEt3Z2hMeTFFaUpGWG5Mc0J5UzBvbDk2L0FuNThTTllTb1N0d2sy?=
 =?utf-8?B?WGE2OTA5b2VZVndBbC8zSXdZNmJmYlVQb1owNk5pcE8wblpxWWRCWUwyajZN?=
 =?utf-8?B?eTNIenFmdnFvd3dIUnVDRU5RZElVOTJWNGh2OXdEQSt3LzVkWFA4WkR3VE94?=
 =?utf-8?B?M2xZMGY0clVKbi80WW5IbE5ndnJMdm5GdGxZVmV4dXJ3M1dGL2VjcnV1OGU3?=
 =?utf-8?Q?/HtljLhPHu+BR+QyvwrdPW8lp8HpnrCMvpnIgsA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26c58cd-66b5-4397-4bd5-08d905c5a91a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 19:34:35.5024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUK1Gu9SkHpuqn17UX9Fr3myIsZF417KwEap9WB80L0LuMNY+KH+AHNdJdT68wFotGAZWqcIjgK7gDjfNImu6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1867
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/21 9:11 PM, Sean Christopherson wrote:
> Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
> KVM will unnecessarily keep the bitmap when SEV is not fully enabled.
> 
> Freeing the page is also necessary to avoid introducing a bug when a
> future patch eliminates svm_sev_enabled() in favor of using the global
> 'sev' flag directly.  While sev_hardware_enabled() checks max_sev_asid,
> which is true even if KVM setup fails, 'sev' will be true if and only
> if KVM setup fully succeeds.
> 
> Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b4e471b0a231..5ff8a202cc01 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1788,8 +1788,11 @@ void __init sev_hardware_setup(void)
>  		goto out;
>  
>  	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> -	if (!sev_reclaim_asid_bitmap)
> +	if (!sev_reclaim_asid_bitmap) {
> +		bitmap_free(sev_asid_bitmap);
> +		sev_asid_bitmap = NULL;
>  		goto out;
> +	}
>  
>  	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
>  	sev_supported = true;
> 
