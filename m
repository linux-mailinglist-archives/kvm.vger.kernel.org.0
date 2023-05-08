Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A2D6FB580
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbjEHQsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 12:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjEHQsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 12:48:36 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50142468A;
        Mon,  8 May 2023 09:48:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ix5G/2+G6KtRxfNzJ2ASEH8AhK6P/sdrzRCnyihm8+aE2b5nUtFbmLr0uqQzyN45+Es1vPaLZtHBF5Fmpq3/aISRcSprC2vIJH27ZjR5MMeU4PC2hfhbAGCu0Eu3XSg+tvrhE2Zd0d5DZv2qmnIS82JVip1imQYl9OsoTvSlqUWkX/S+UBkHRTnU1NWUhxGVaHaG7qH3XvhHSBeUHWAVv2ewflcVNCOGKdF8ps6B/EOliEfMYM9H5kIlgrJtrxpmm0dwmvpUiCj5VfIY9+oTu5n8YXArsDsQhg2IlMzsUghw3M/wDbjGuCPRpXiA5Gxti0rZ6ZEl1ZfSUCGDugLHhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jr5dkqDor9+bfMYDG0D0544k6FAli10DORylr7SYxLc=;
 b=dS6zizLmga4ha9GvHMLXVQT6IOFf47EpeqyBYyfEYHVLKNXz7GyGkJWY7qHGYYy6g/Zzp0DhuY0JLtI45Zr+vrRng2D0QfghT8NwvF7YDyWaz3O8bLKlNqbDQ9aZKtUaT7XbaVv2jw4Zsi9etdJKuMx8Z8Vg0ZdyE8Z3lMWeBAAtQlVqoEuqUszuellrs6eVEunp9z9Zr+sePHzWFs4CVwN9MQuZKboKok8zwI1/MGlgkwlFvU8SAbUXNYNhbTuXBTt5u8GQER+rrp1qmbO55OLp9rznYrI/LmtXV1i/roebq2jaTi0dnY0+euoX4lMmLwSe5d7wf9da9NyaGjJB3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jr5dkqDor9+bfMYDG0D0544k6FAli10DORylr7SYxLc=;
 b=uAsgVuYQhHO0Ivl8DVt14fMY3nWxGJjnHrngHKXQ9gqSQ0nGRfiMyozBRTDJGijUN3sfIK6FdLJ2ZvSumPiLsTLnFjB8s9x+UKIRlsePX98TsxDME+vqWzGXM/sU12whofUbKeX4cchk70jWdouJCtHVoVnk4o1sKoYx0IrHXhfbiyh3PMfnEEumB48MbICLeVWQAuztkMhBhoinOYqBLLET5AtpotX4tNr4jUJu8ugH38W4RPJTZw99sgv81rIcU52uXUhwT6MSFLb+adWh20EL3lrOMhq3BR5EWADSUtYygiEEuQmEGiDn2wNVCaHbMzBCAFonCPx25E50/sm3lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 16:48:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 16:48:33 +0000
Date:   Mon, 8 May 2023 13:48:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kevin.tian@intel.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <ZFkn3q45RUJXMS+P@nvidia.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508125842.28193-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: MW4PR03CA0310.namprd03.prod.outlook.com
 (2603:10b6:303:dd::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6163:EE_
X-MS-Office365-Filtering-Correlation-Id: 89a6653f-5746-4842-f14d-08db4fe40f27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzqIjJ/j30YWW8YtGDoWGsOvVc+HRGUgTskUQyiPk7Rb1vYnFS8cfhjKe75dR5Vo18p+UzsBK5oWlF+zFK4k74+QB5cfwLGeNJO2RRMffdKZirMVjfhRzBcMWqUf+SzLEtAlb2QdHlr6xjyWhBlaaIkkDgz+UgHETaPhF+StIaSh36TDpyW9Mg8BCiP/2lRYphHixrJ7iSiWS2ooAG0nhEY3RWoNfT0DqbA4ru5frI6gJrZ43UKZwD/gJ6RgMCAAKxfJqjpj7U/ziEK8I78nVTew0Brvyy1tzHwrlEL/a6cP/y+RFOy3oj6IRqzhL5cBq/AIym0AW0OVdOzXLXEeiZBN6ACvTiZKutOZq8NzVZ8fq68Z2WkZswdkA5ur3oL0oCSBgStwBdVxrQjpoQC285u5hWhWb2AXaS8+S2w4/Z6bmEHOFRihTHPgtY0xzKWIEKEeV3pYiBhHj5b1C9SLwM2+sMC9/lhThYnda2772Ws7V0veWtunwH89LRFHtFQ/5NBCJW8c6/5/mBG61VqiKqmQfBL5hHInbuzKXnX/M1MJk32iwuvcoZXWGKGjVrTe/xhC7IWkZ7nEQAJZ0Yp+vWiGnsLBCYXqLQj5dxez0R+GBewdrjz7TrGEpaCBBGzZIrohGw4eTbybtDEiVC1GZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199021)(966005)(66556008)(6916009)(4326008)(66946007)(316002)(478600001)(6486002)(86362001)(66476007)(36756003)(83380400001)(6512007)(2616005)(26005)(6506007)(5660300002)(8936002)(41300700001)(8676002)(2906002)(38100700002)(186003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pdQ/h1l2CUn8tbI0zlrVSkJjDd831yl5xWHhgsCW1GkqXyuPdJb7qbA09V9f?=
 =?us-ascii?Q?cewAitGtjiaUPndLnV4/oDig0EwfAos5gOKneS4cJz03KifynGyHFY0dsZ5v?=
 =?us-ascii?Q?so3RASLRNhkeNBIYz3Epw96d6PDOk4f0WNfBFt48E4qrlduBIPBg66T/GOvh?=
 =?us-ascii?Q?jyeALV5xMAg3hfxmgHrRZjld4tGEu2ZQTJ9evcZQzlwq/PZsRW+HmS0fYsz7?=
 =?us-ascii?Q?jqcBQg1n6ricmfaM77RwDq2xfBDrXlm4F9M9QJ7WKVf4jgO8/JbDZEsxnJhb?=
 =?us-ascii?Q?s49W3hDsws3/PJ457xZDBP59jfgxzL3iuCJkTH/bUpJefD/lFF5e/MaaIRVW?=
 =?us-ascii?Q?xKw61sFuKc1LrByDOiVr2nXFhzOfSaak/YaVSpQfmkSFuvBJHku0VdmFxc3t?=
 =?us-ascii?Q?M2HBeadjZQRgOS1ZTjTNxE/kjM2NpsMerdCDF+pnj/RmZaGI4oE6Q1nYByXs?=
 =?us-ascii?Q?QOxfRYDeah+ljbtAUDiYyTkeFcTfQNEd/e9bZElMss/MopD6R7E/IRSut0C9?=
 =?us-ascii?Q?uICDVXEaGV1h9zfIY9imdU0QlIinkskGXRTs6yDCxfPtk2da+kjmuAexn9xC?=
 =?us-ascii?Q?Gx+zw86vtbfZFkWbpzoZbaDDFmaAupqt7/ibf/HxedT7CUrqn4+A3FJPRQ9q?=
 =?us-ascii?Q?oddIZX0MI1SF1F9qqZeMAnWebGt6hS8xq4ADQoNUtRKy6amB8PFRqCKRpjnU?=
 =?us-ascii?Q?9TJqJwJUf+l04safet0mYE/SjPvmksmXeOSdSoVE7kG3EZc3DFwrShcN9CEk?=
 =?us-ascii?Q?BMz0/KBVL9PWScZoutotz+HtTHKibtcW7WTbU5Y9LNE1uQ+Q5Er2Md2+oFlV?=
 =?us-ascii?Q?6ZydBy1eiAow7CLEBE8DOPBMhmvuGikFTKQ5dSw5++UD2aEqm5/1OY1hV7PF?=
 =?us-ascii?Q?pDwpSkfWribg3WzT3RMf3wnoXJMNz6lsk8Sq0m/4C1/uLfftfmCYilICvUI/?=
 =?us-ascii?Q?pMdnglTR/7yYpzwOmDJ4y5B2xXiBrIHeEfSt84tEK3qqCvdNND/ysiITSTj4?=
 =?us-ascii?Q?wH5GcRG7C8w5iSDR7wX6/JgX6JHF4uj+AKhhJPP4uH3L0jAIG8g4l5sBpPWM?=
 =?us-ascii?Q?k8MJdtmreUDm4R2rSHzCZdqkHntfG5AtV9Le3hdo96kvUS6oIKomNQXObmpd?=
 =?us-ascii?Q?fotOiljpI9hAD2fwOfu08DEp+HSpCd1UNeRgDw/rMCgKAUBohi5fAChHGsZp?=
 =?us-ascii?Q?gvvSv0lZGA8j3DPODK4U3ikScZ3azN7PitA/vJ+2e5e5BKqcUCXQx9lSMv0Y?=
 =?us-ascii?Q?aec706p+WBG4Yb5tOerXiyhcciTWNOgk5cCX4RnucTAtRLhyAIxpTJ0HFTRQ?=
 =?us-ascii?Q?rOEhvP8+x2qOHf5ZyYMJvQB2SmDxoME5Io9nqSQ+OLuuVKMO98q7q4CMUC/X?=
 =?us-ascii?Q?YhIEV7NME0d/kce22iOxjtw78XFO2Rf6K1Hkh4JV50GWL+H07EBYhX7noukj?=
 =?us-ascii?Q?3LnMv7Yhsemy2WKJNGLls87S6gO3CyCLzmHlQfAOGpthufFQVMMo5SbWE2D/?=
 =?us-ascii?Q?ZpKw0NCRB5O0Puo34Kh8g5+JOgd83yhfqRZDupHpik1W/Pte15t5TIvqz1aL?=
 =?us-ascii?Q?vOPibgSuEnof4bJx0HI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a6653f-5746-4842-f14d-08db4fe40f27
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 16:48:33.0246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XTrjR0TKDL6iUNl0wly0O+xRZnywA+9c6Z9XMQbhBSFYFsDUdJY3n226rK5QlNTg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6163
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023 at 08:58:42PM +0800, Yan Zhao wrote:
> In VFIO type1, vaddr_get_pfns() will try fault in MMIO PFNs after
> pin_user_pages_remote() returns -EFAULT.
> 
> follow_fault_pfn
>  fixup_user_fault
>   handle_mm_fault
>    handle_mm_fault
>     do_fault
>      do_shared_fault
>       do_fault
>        __do_fault
>         vfio_pci_mmap_fault
>          io_remap_pfn_range
>           remap_pfn_range
>            track_pfn_remap
>             vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
>            remap_pfn_range_notrack
>             vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
> 
> As io_remap_pfn_range() will call vm_flags_set() to update vm_flags [1],
> holding of mmap write lock is required.
> So, update vfio_pci_mmap_fault() to drop mmap read lock and take mmap
> write lock.
> 
> [1] https://lkml.kernel.org/r/20230126193752.297968-3-surenb@google.com
> commit bc292ab00f6c ("mm: introduce vma->vm_flags wrapper functions")
> commit 1c71222e5f23
> ("mm: replace vma->vm_flags direct modifications with modifier calls")
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a5ab416cf476..5082f89152b3 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1687,6 +1687,12 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  	struct vfio_pci_mmap_vma *mmap_vma;
>  	vm_fault_t ret = VM_FAULT_NOPAGE;
>  
> +	mmap_assert_locked(vma->vm_mm);
> +	mmap_read_unlock(vma->vm_mm);
> +
> +	if (mmap_write_lock_killable(vma->vm_mm))
> +		return VM_FAULT_RETRY;

Certainly not..

I'm not sure how to resolve this properly, set the flags in advance?

The address space conversion?

Jason
