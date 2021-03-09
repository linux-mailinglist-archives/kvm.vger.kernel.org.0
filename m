Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABB0331BFE
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhCIBEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:04:44 -0500
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:45473
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229475AbhCIBEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:04:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7p5YDoh1uVU/WuZxIa03X32JVVJpX3vjnS/pLpJ/MfTovspTj4xVm7+B7MPMOuKPKoUmyd1rmWZJiiydcXW7HNDeFifXAMhFeEy87EI6Le1EN3KXkM74ZgIiRJ74mw2vEuWAViZyX1jlRRW3SL7F1Bk4BihsYaxC29eD8eKEUvIFHm9b9mSPAVJCfpufScW9QplTDdwPKm9IAtWNWMFHM25atC2E3nwvvZrEiZwT8yYJunZHp+mIXIHqDTycjbmO4WX3TDpV0qAhlvUNp6LP6fVYKTAjlyf/FeuWOYo/RKQZpdKy45NdgrA5iSH5MuLRZZ9yp9cjU0zJVAXC0SZZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMBuQRTN64bEPa95VZUk14Ud5IFaCPRstO4LFQOM698=;
 b=FDSTaiTuO9gWO+0d3gduA9oto/EqyIMv8z5sraK3le5e3lQ3UDG8u6evZCewJn8GxZ/QjfdYTJ8uSY/mnWMjWk1COA3RX68RJrnTEGz5YLhZ/UlmPsTmm05eEyVA2j7Ej6hJhVOlOCm00B/sV13Q4RoskhJ7tMd0R65MmulazdxOsJV56Obd1SBSjdiWSmvvjOVFV39HGuTuHqrY6RQNrAOugBGoc9mO6KBSNVvCaVW4+YbkEAfSDlzM0H2H1FuUtMcmA6vPlGHaRTE6K6ZCbBQrwXRccbjz8hQvLC9xe3J0+dJGMMmWD4776BILJ6bKDb2DwBkghnbTTfxnEwQcxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMBuQRTN64bEPa95VZUk14Ud5IFaCPRstO4LFQOM698=;
 b=VkmuPL4V/P44TCWbIV23G3Bhp0Y4JOhGtVXUw6W0lTGNGeCa84hkxkr2lfS8GF0IK7029y3wk8ByaFPu3YuJdw3dm2/h2yXcNqoWDeCaG9UFGqv+u/46MZlUDoViLhXpftLns4O06F5wS7ynUdTDcp3hyIatKxV+JHxct8uAVtc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2439.namprd12.prod.outlook.com (2603:10b6:4:b4::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 9 Mar
 2021 01:04:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 01:04:07 +0000
Date:   Mon, 8 Mar 2021 21:04:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH v1 12/14] vfio/type1: Support batching of device mappings
Message-ID: <20210309010406.GE4247@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524017090.3480.6508004360325488879.stgit@gimli.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524017090.3480.6508004360325488879.stgit@gimli.home>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0099.namprd02.prod.outlook.com
 (2603:10b6:208:51::40) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0099.namprd02.prod.outlook.com (2603:10b6:208:51::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 01:04:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJQn8-009sxs-1H; Mon, 08 Mar 2021 21:04:06 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6ccdd9b-e7bb-458e-cbf2-08d8e2973d8b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2439:
X-Microsoft-Antispam-PRVS: <DM5PR12MB24395943C9866D262C3A5B22C2929@DM5PR12MB2439.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iifcP9FXqLDipg/jwXpXqb+ivR4PKpms71Dp5sSICzPqjACX9WohsgXCxgBGJeAqNApMklbmk7Dbrmj8Qq6pOzx1RC/E2I5W5HYTLNXewDPWTM0jIJkgdqwELsMpq4EdHYQ2fi79Hc/r6SG3mykMu0Wdl2bsX9fGS+vwKoUNjMMXP8S9agLckghtilI5xT1QtXsuYAGqbzBnOBOi0yjUcSqCSq6W9+ckwiWnVeWM5gIlFAWfFzia1XIFd7layQO/nLQm/PjDNh2hiX3Xz81W8fMeOMju8haTpnHBOzlSuckAz5hcOODlAJHOKWE0oFo5RipWZvckRYsDtpQMjsZvq/cHhNBEDNXnBc2cNGC+41bNQ4Went4ZBfiUTgB/zy/mIbQoujVOb5APPx10P+FbHTtcypynIhHqgT8soflis8jOoqmOQEjf3Wqjf636yOGNOTM1SsTjnniBHNlurTWG01GJOmokGzPGEeQiF5X9nXfnoTOYKFcfwz2q/hKwPc1DBGD5uGYLnB7G8Np218FM3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(8676002)(36756003)(5660300002)(66946007)(66556008)(2616005)(9786002)(6916009)(66476007)(1076003)(2906002)(9746002)(8936002)(83380400001)(478600001)(4326008)(316002)(26005)(33656002)(86362001)(186003)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vDWIDcgblRrMkgfDi753l2Oxf7u6OCiHScjdOTIZSbH1ZYac1HNvVAa+a5U7?=
 =?us-ascii?Q?+QlXvVPqB711eza9hkDNBCJncRlzELua15HI/pZ/WoP3UETzFQVtvCl/iF7S?=
 =?us-ascii?Q?EbpM4NqXCvXoJ2rtA84PBXkaKipc/NHOlRmXw+0AWofOuwdVC+p9tbYN/hyZ?=
 =?us-ascii?Q?KYHa+uZio1U/+YjtU9g1C5LLE7RQutUDL8m614EwtgvmEL6VN5QwvcjrhetC?=
 =?us-ascii?Q?PTAQzIx0ez8K4tnMu5zOIaW6XS91fNZBVTWdOeJ/7u3FUc7+RsIB7fLu13Ek?=
 =?us-ascii?Q?6pGbtGl8J2t9T4W5cW9k91Q69Mmr/aBx2YoOVMSV7+3hy0P1dczHVlA1pstS?=
 =?us-ascii?Q?58HNOdbz5TrnSdhEmvPnaZaYpJmXXNoIGutTBD1dJYcrs0IdiPMJ3OwQTX09?=
 =?us-ascii?Q?7yagzd0pHZHhYkRfYNFRIMqfgrdG1saoks6/95zRLnrFdycv0o55ifp1w9Hv?=
 =?us-ascii?Q?2kHKpBXte7zyaQmkCTb3WfVbnSLxTGeOHoUknZOBzWM2fUj3aPgJWpXg+YJW?=
 =?us-ascii?Q?+XQY3NTlKLlO5njoDxX/UwDq1MUwn4rIuM/PvqwiezTHPfcau7IjNCtPCUeR?=
 =?us-ascii?Q?V/JpOvBO/HjBYLvtNt6s2kdxhJkFIQ5Jj8fd7dETyb6cw6yzDphtH/8tMVhx?=
 =?us-ascii?Q?TiZDrj64mYp1NCBvDgzo7eQD2JNISd4eNNi6d8xf24tB+QCbKsrD3oD87jMx?=
 =?us-ascii?Q?o18gqyqmIoL+xE1rkXTLBuM/9nOLtQSVSGiWthWSmXcw+Fa3wL1mCf9Pm00J?=
 =?us-ascii?Q?sYMpY/yVFIzzTOFF5qC4tyX/jaoLUFrFxhFnH/5pJ5uGMttB51a2Vr6+I8+z?=
 =?us-ascii?Q?gIhnKwrQujZdi/lKy3+hXCf8VGCa1E7lj30vdd+TvDjjybq9e9VpoaN0z1/y?=
 =?us-ascii?Q?JKrZpQvi8KX6KQ+3vW+ivjVIkzN4J2OBupuYohUXMH+wsOjC5ybIlRogua7f?=
 =?us-ascii?Q?PffP6HjllEEvz8co0oO2x1hp4Uvh/RVNLfwqsuPsq5J+gFsTElWyoWyAHMrh?=
 =?us-ascii?Q?CKwZF5wXlI49o3nECayjYZ3u+eS5BuIwOqFnONK0AAv1MS1cp//Y6yjkAvZk?=
 =?us-ascii?Q?lwzokQGpisaiZCOpZL8VgplHpW+L9Pth2csOQH8nueseQzW1V9VipkSvkTbE?=
 =?us-ascii?Q?8NOkF7R1Io9VG07+/eztAhoNAW8HwWhcX8LeqjdWSqKCSOKlMh0XflhHm2Yc?=
 =?us-ascii?Q?htpQGzvzyotMuNLsYtFsNEhHlSJu6ff+oRsEIt0uSzJcX5g0Ve3TKkhpucQI?=
 =?us-ascii?Q?1fVg+nWYz6zqHjNmarIv2eVrK1ZUZpKQSVDmekdunfbdIKc3LQl5S1cWTfGQ?=
 =?us-ascii?Q?LtBB0/Mc7S42A/jKqbbDXycZa1Cz6lWn2rzargDHxw6eQQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ccdd9b-e7bb-458e-cbf2-08d8e2973d8b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 01:04:07.4945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WrKZ62bc4eT6h2zwmYobP+g33DY+CVt7p9eL/EEixsltvPAinI5c7KiUfZTlOepd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2439
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:49:31PM -0700, Alex Williamson wrote:
> Populate the page array to the extent available to enable batching.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>  drivers/vfio/vfio_iommu_type1.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index e89f11141dee..d499bccfbe3f 100644
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -628,6 +628,8 @@ static int vaddr_get_pfns(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
>  
>  	if (vma && vma->vm_flags & VM_PFNMAP) {
> +		unsigned long count, i;
> +
>  		if ((dma->prot & IOMMU_WRITE && !(vma->vm_flags & VM_WRITE)) ||
>  		    (dma->prot & IOMMU_READ && !(vma->vm_flags & VM_READ))) {
>  			ret = -EFAULT;
> @@ -678,7 +680,13 @@ static int vaddr_get_pfns(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  
>  		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) +
>  							dma->pfnmap->base_pfn;
> -		ret = 1;
> +		count = min_t(long,
> +			      (vma->vm_end - vaddr) >> PAGE_SHIFT, npages);
> +
> +		for (i = 0; i < count; i++)
> +			pages[i] = pfn_to_page(*pfn + i);

This isn't safe, we can't pass a VM_PFNMAP pfn into pfn_to_page(). The
whole api here with the batch should be using pfns not struct pages

Also.. this is not nice at all:

static int put_pfn(unsigned long pfn, int prot)
{
        if (!is_invalid_reserved_pfn(pfn)) {
                struct page *page = pfn_to_page(pfn);

                unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);

The manner in which the PFN was obtained should be tracked internally
to VFIO, not deduced externally by the pfn type. *only* pages returned
by pin_user_pages() should be used with unpin_user_pages() - the other
stuff must be kept distinct.

This is actually another bug with the way things are today, as if the
user gets a PFNMAP VMA that happens to point to a struct page (eg a
MIXEDMAP, these things exist in the kernel), the unpin will explode
when it gets here.

Something like what hmm_range_fault() does where the high bits of the
pfn encode information about it (there is always PAGE_SHIFT high bits
available for use) is much cleaner/safer.

Jason
