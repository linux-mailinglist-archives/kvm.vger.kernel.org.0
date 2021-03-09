Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9335D333209
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 00:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhCIXp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 18:45:28 -0500
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:50528
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232165AbhCIXpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 18:45:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQDGQqqgVW/GA322sjkWJKnRRFv33gUANiwf9qCnGlmVLvnG86fX+inOXuneTwf+uPqFyLJfYfh95qN+/OhJ2UIfJocXukq8EtbWtDQVFobQrV0M3CNHMwQ+diZI0BhxAjlpH/jN1qSKYC1k00K7c896jJk5cnU35vaToOSRJOU4R3cp1TfJvwipyBmF5JS78DN8gXyUCl7AmJRyaeQht+wi/S4QLddEf6TQYb5Sq2Dv7tucXOkIDTGjK9QwRHgmia/rmC6NFuc7hLkinAJE1fUWOtn7vdTXyUmVMVDd8jKlA+DN0yXdD2mEWKzUZkHe1BH8+nTp5tuWoiNLnyO79g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqTiOSiOIWZE1JtYkfoeJhkv3njAKST/hMDHOWOUl1E=;
 b=HnOuFQYtwxaBw8QmTwlB9scG5LDvVafV9CUYQcGyX1juzBAHg6kBzdHKa5u927y3+uiFSDnsRhJYdWoLhgtdxNdrWWbO+SocrwmpcllY72ieGwgRjtOykCfIfmfLnFdbkGnEfzL7jv2ednbk6CO0h9OIQCDVnYYfA9yz5red2wxpnRpz+Ci3uT0iJQCHUWZKJu6qX5gFBFZse/TS0aXNzjNil2/d17LX5RtZqyb02Tb1He2XA2IqAEGQ7rcua8HrS7RpenTwxJhjVjraAuPTzbGH0mEj2k6KEljTyaKxgdqs9vKdkD6rTa0piGyX8gJ29sGQBYXE+JbgvDKKot+17w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqTiOSiOIWZE1JtYkfoeJhkv3njAKST/hMDHOWOUl1E=;
 b=ocXDwyoH5pPRREWf0t7dKnKArJwhpYrGXY4rgPWLgeQbLnYXUhWbYIuMB1Llwz37VruhMYVfRz6bGJaomtkusEsiiUU49hQsVunymOYqQOBllcJjoUAq4zUAZpiStd2cc4hwTyAMaTc4mxl+dj7XCJtBDkeQXiCl2B8DK0dp0bfnYwHo78o3x+dRE82VspnLNK4pNOqpPUkpxHIcberEDqCykRXkHxzULakXPEr8dOkp8FVrysdNwQecGsVol/H3GFywgHWt1IbmSGxE2quJitzzrUXaEpPz6cEhfq8MCVMjpXNQ4gR9UPar4Hfwl1Ahwmre0slS6ORIXuks9FBSDw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3210.namprd12.prod.outlook.com (2603:10b6:5:185::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 9 Mar
 2021 23:45:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 23:45:05 +0000
Date:   Tue, 9 Mar 2021 19:45:03 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210309234503.GN2356281@nvidia.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
 <20210308132106.49da42e2@omen.home.shazbot.org>
 <20210308225626.GN397383@xz-x1>
 <6b98461600f74f2385b9096203fa3611@hisilicon.com>
 <20210309124609.GG2356281@nvidia.com>
 <20210309082951.75f0eb01@x1.home.shazbot.org>
 <20210309164004.GJ2356281@nvidia.com>
 <20210309184739.GD763132@xz-x1>
 <20210309122607.0b68fb9b@omen.home.shazbot.org>
 <20210309125639.70724531@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309125639.70724531@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0439.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0439.namprd13.prod.outlook.com (2603:10b6:208:2c3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.16 via Frontend Transport; Tue, 9 Mar 2021 23:45:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJm2B-00AXG4-Jg; Tue, 09 Mar 2021 19:45:03 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bbcf0c2-8796-40b0-45ae-08d8e3555d4a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3210:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB321049F10E3D0D36F432E160C2929@DM6PR12MB3210.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Utnua6lSLp744MGbeySqle5X5h2vLlXWF5bMXCneog7cn+NrJnuPYYasyl448JQgtHBfHQ221OmjfiJSmJjImfoudXtjKc8f+cx7/iahp3U64kjhCs5Ndq5dHDxsuv6FTPcEdA950L2JL0Qs2MFknslBplHHhzX4Jhhna7iwIzFMXg6hRmQ8RORv6YeAa89MhKyETX2NpTLtD1boyEJo9NTeWo9995BQbFzeFhT/Hx8+TPhpkIMk0B9hPYucdD+x1mruUBGFjYfElTAXuhcQWB1f6ls4W33RqR4KEhGG9b0V9Gxk55Zm5wlMw/LHo2QDVM+wuwMSv6COg+ebaTZNdQBFO2tiVrX3FXfmNjz7DvfyluzQxANMZJQSHr/uHI2N425SDIDaYpl3WYUxKxRQavQaPGH3/Rbm2vPXekEGrXEaWmqdRVDFxi6UXQ1LV0DRQDgSF8BlVSefsaymhF5/tOPJiXLJ7YxBB6Z0xfCRMgI9jRq91wNGqFbZkf/U8NGXW976cJAQZH5Ce8wvGqQVsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(1076003)(8936002)(66556008)(6916009)(86362001)(26005)(33656002)(9786002)(8676002)(5660300002)(316002)(54906003)(2906002)(478600001)(7416002)(426003)(66946007)(186003)(66476007)(9746002)(36756003)(83380400001)(4326008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r5xDpSS+gjUSMGOLjoWzyvt+y1CcP+GNR2pfFJ7pbODEoWhal/ErQy5SNiKr?=
 =?us-ascii?Q?RZcvcQp6DdF1WokDW8KY0MEWTzr78+NBX13S/5hTWA4hHiqvpZujQkoM2yKe?=
 =?us-ascii?Q?U9lp1gfnYIzf7tpM40ZAuk3uKP9Y3JLvv0kqoiAQVAVTrNBVPEVVAHhO9cjd?=
 =?us-ascii?Q?Dq/5YHkE9aFRaxBD1vDAbyPaiGzB3B/1rWbydn55ncvNUFv1tHZsy81Udt6Q?=
 =?us-ascii?Q?y6TI023eBhldJNoFZDbeuZWCjLiV8I7Xx/VuekR08f7e41YbPOA96rCG+4JS?=
 =?us-ascii?Q?AehmxB6426iVLqV6hSfU9usiJXMud/Tzz4VmW2/kWzAuEAwia/hT2XIY4KfD?=
 =?us-ascii?Q?IoE79urqPP2GJ2dhBp6LLocXFLHtW4t/uubCNoc61xgd4S3e7wrSenBb/SRw?=
 =?us-ascii?Q?FAiRjyETkkm9p9MYSo9aYvmPWR712e0zsBsfnj+b/9XPKTC4Qg+ZTXRJz/rc?=
 =?us-ascii?Q?T4AhD3B8F/LjxaUzFczcBT9/ly3fcyNExafBY0jIYNk74WsRIKX1lvinOGQt?=
 =?us-ascii?Q?0BmL3615UsVzAVXczfXcslNnpajw06XtnTi+VnGw9arXcP3XRpYK/0rPJB8r?=
 =?us-ascii?Q?L5t8N9cp4g607zS7ceLk6yOKWYb3iXUql00wlLuNdcQgH64RCWDONvKiHUz3?=
 =?us-ascii?Q?2MVGnbyRvkGfzhy7S4VFd8oK3OU+9mtnkDMd/AMxN4py7k3iF4m/YlNpBg76?=
 =?us-ascii?Q?zXowd1Im2ZvYyvax+rZny7145XwWwzr95Qk4HOG2ja9W7t1D4w5aUxrDQzmU?=
 =?us-ascii?Q?if5J0/9vLsTyi4X5rCwoNociUcE4+1287csvFDOMDLuCbKwyMkST6+xASsBt?=
 =?us-ascii?Q?bow3XyNKFzKfSciyrJ05X1hDkmrgwgRukKiPDvBUkzwNNN6xrZarhlXSxbMq?=
 =?us-ascii?Q?RD84l0D5cPo13eJX2Ae4yN3lzgIxyNuIn3YUJ9KqMEN0BtqwFM59dTbfVCJE?=
 =?us-ascii?Q?z5+Jbm5ms2WGi6t5TbpLePag61teJ2bqOmf3rb5C4DtnY71tyYcpVXW2zpbo?=
 =?us-ascii?Q?7ZBoaf0s2ZsukeTZUWAL06Dmj9AjuSXc2M7klATio9RMO3Ag9RR1pVfkVoRg?=
 =?us-ascii?Q?7nZugrrgBlwJE72NYL8f90oVdPYsc1LdEda+ksPjtcRd5wa4Od9EOB0Nfr9P?=
 =?us-ascii?Q?jBzy1usYMTxg85yo7SLapLKYcZCHKIboZkt0BDL4/XEg3ZE9F1cBFT4z0iJt?=
 =?us-ascii?Q?cbDwBmLLmK2/i+wZ5txAEL/f+2qLSWfIDNTmzL50LzbYmU2KwO4Ija16vggL?=
 =?us-ascii?Q?Fx+XUteoxVEL8ouwETr9nh5CRvnExlgfcI4Swy8zaUKdtUnEVKFxsGoJGjQ6?=
 =?us-ascii?Q?iyd84vshzLWOvz4AuLsSKE0BUNBpveXsU9l3fclbqKUrUQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbcf0c2-8796-40b0-45ae-08d8e3555d4a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 23:45:05.8424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NEN8V08DXHOgMRJG2OG9fBriVX4b2rNXjmzwxWLdg1Zy6VDDc0KVLuqz1kPZIOx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3210
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 12:56:39PM -0700, Alex Williamson wrote:

> And I think this is what we end up with for the current code base:

Yeah, that looks Ok
 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578..2f247ab18c66 100644
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1568,19 +1568,24 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
>  }
>  
>  /* Caller holds vma_lock */
> -static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
> -			      struct vm_area_struct *vma)
> +struct vfio_pci_mmap_vma *__vfio_pci_add_vma(struct vfio_pci_device *vdev,
> +					     struct vm_area_struct *vma)
>  {
>  	struct vfio_pci_mmap_vma *mmap_vma;
>  
> +	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
> +		if (mmap_vma->vma == vma)
> +			return ERR_PTR(-EEXIST);
> +	}
> +
>  	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
>  	if (!mmap_vma)
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	mmap_vma->vma = vma;
>  	list_add(&mmap_vma->vma_next, &vdev->vma_list);
>  
> -	return 0;
> +	return mmap_vma;
>  }
>  
>  /*
> @@ -1612,30 +1617,39 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
> -	vm_fault_t ret = VM_FAULT_NOPAGE;
> +	struct vfio_pci_mmap_vma *mmap_vma;
> +	unsigned long vaddr, pfn;
> +	vm_fault_t ret;
>  
>  	mutex_lock(&vdev->vma_lock);
>  	down_read(&vdev->memory_lock);
>  
>  	if (!__vfio_pci_memory_enabled(vdev)) {
>  		ret = VM_FAULT_SIGBUS;
> -		mutex_unlock(&vdev->vma_lock);
>  		goto up_out;
>  	}
>  
> -	if (__vfio_pci_add_vma(vdev, vma)) {
> -		ret = VM_FAULT_OOM;
> -		mutex_unlock(&vdev->vma_lock);
> +	mmap_vma = __vfio_pci_add_vma(vdev, vma);
> +	if (IS_ERR(mmap_vma)) {
> +		/* A concurrent fault might have already inserted the page */
> +		ret = (PTR_ERR(mmap_vma) == -EEXIST) ? VM_FAULT_NOPAGE :
> +						       VM_FAULT_OOM;

I think -EEIXST should not be an error, lets just go down to the
vmf_insert_pfn() and let the MM resolve the race naturally.

I suspect returning VM_FAULT_NOPAGE will be averse to the userspace if
it hits this race??

Also the _prot does look needed at least due to the SME, but possibly
also to ensure NC gets set..

Jason
