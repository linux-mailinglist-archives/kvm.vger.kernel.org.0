Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE3146D98D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 18:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhLHRYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 12:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhLHRYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 12:24:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904A7C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 09:21:05 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id l25so10657647eda.11
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 09:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kyzUDdWg/IZru0d+jvuosuGK1ljLUFNTnYN5AnSJDXg=;
        b=hGOd2DXmhiY03/LW8kR4Fzs1XS4MZrOOYMgzFNQlW3QzkFSk0fHm+jEd/hfPuPbUb9
         jSnT9XG/E45e55goXHXwup8OV7EvMpUz5YnNTNX8PbokPB7LTAxr1wb5fQ18JoSR+2dz
         7W1sBx32q6fKcJPqvMKo3QEL8pDUncUpdrqmwNkimOqstmKzRVi1Glo3tl1CAITnwBWr
         SOzmUV4zL1L+qMphMN46Lq9w0u/Dqo94EqVT+RPNai0wEVYekJ/OXqJbzatlyLjAJsHQ
         woH+/w4futuTQIP1iS9rns7q+IdTvoky7d4omWrlfeXiFlBWUcvwxrhrYkDGQtgU0O1M
         tBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kyzUDdWg/IZru0d+jvuosuGK1ljLUFNTnYN5AnSJDXg=;
        b=S8FJW3xEt+GhnadrGwgoKe9ypVMBxmqFgGDrPXN+Uo1xGdq6qIsgiEEk+vKlC14l3M
         QGDU7CUedkLgoGKjltz6x7I/pphoygak47WAN+vwZPzwDXgbuGdQ2uUakJaYIVnPF+cn
         1Pfq7lsp+4kTwAhAxqKgeSceND0xntAvLbEw1M2a4mnLjUNB83K60qKuY9jScVK8Y/9k
         W5cdqd0bIcf296hYy0Odk7zZbf7obLph2oiWZy4dinTiG9CWyM3qC2nNU6yJhqrJMQxO
         EEi5nYquOi3l20bCDiH+pMGe5U/NfYG932ubuM9ue/DKS8quHJCkyqV3UrJ6TVGlDObl
         M2EQ==
X-Gm-Message-State: AOAM530tHYoroqoo4eeLnu/bNZIIT6iMBVLvtST4rCrpMyC6IQfpmWsv
        tfxXI+ISTmnCr7rZeUkl92QXpg==
X-Google-Smtp-Source: ABdhPJyjFzHce2qFbF0BrVsh3LEu7RhsZDOw0Mq4d7N2tuvqt9QjnSMjbiA5jluzcVko/W8H288INw==
X-Received: by 2002:a17:906:b084:: with SMTP id x4mr8967385ejy.214.1638984063404;
        Wed, 08 Dec 2021 09:21:03 -0800 (PST)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id b11sm2484409ede.62.2021.12.08.09.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 09:21:02 -0800 (PST)
Date:   Wed, 8 Dec 2021 17:20:39 +0000
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, vivek.gautam@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
        ashok.raj@intel.com, maz@kernel.org, vsethi@nvidia.com,
        zhangfei.gao@linaro.org, kevin.tian@intel.com, will@kernel.org,
        alex.williamson@redhat.com, wangxingang5@huawei.com,
        linux-kernel@vger.kernel.org, lushenming@huawei.com,
        iommu@lists.linux-foundation.org, robin.murphy@arm.com
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Message-ID: <YbDpZ0pf7XeZcc7z@myrica>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208125616.GN6385@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 08, 2021 at 08:56:16AM -0400, Jason Gunthorpe wrote:
> From a progress perspective I would like to start with simple 'page
> tables in userspace', ie no PASID in this step.
> 
> 'page tables in userspace' means an iommufd ioctl to create an
> iommu_domain where the IOMMU HW is directly travesering a
> device-specific page table structure in user space memory. All the HW
> today implements this by using another iommu_domain to allow the IOMMU
> HW DMA access to user memory - ie nesting or multi-stage or whatever.
> 
> This would come along with some ioctls to invalidate the IOTLB.
> 
> I'm imagining this step as a iommu_group->op->create_user_domain()
> driver callback which will create a new kind of domain with
> domain-unique ops. Ie map/unmap related should all be NULL as those
> are impossible operations.
> 
> From there the usual struct device (ie RID) attach/detatch stuff needs
> to take care of routing DMAs to this iommu_domain.
> 
> Step two would be to add the ability for an iommufd using driver to
> request that a RID&PASID is connected to an iommu_domain. This
> connection can be requested for any kind of iommu_domain, kernel owned
> or user owned.
> 
> I don't quite have an answer how exactly the SMMUv3 vs Intel
> difference in PASID routing should be resolved.

In SMMUv3 the user pgd is always stored in the PASID table (actually
called "context descriptor table" but I want to avoid confusion with the
VT-d "context table"). And to access the PASID table, the SMMUv3 first
translate its GPA into a PA using the stage-2 page table. For userspace to
pass individual pgds to the kernel, as opposed to passing whole PASID
tables, the host kernel needs to reserve GPA space and map it in stage-2,
so it can store the PASID table in there. Userspace manages GPA space.

This would be easy for a single pgd. In this case the PASID table has a
single entry and userspace could just pass one GPA page during
registration. However it isn't easily generalized to full PASID support,
because managing a multi-level PASID table will require runtime GPA
allocation, and that API is awkward. That's why we opted for "attach PASID
table" operation rather than "attach page table" (back then the choice was
easy since VT-d used the same concept).

So I think the simplest way to support nesting is still to have separate
modes of operations depending on the hardware.

Thanks,
Jean

> 
> to get answers I'm hoping to start building some sketch RFCs for these
> different things on iommufd, hopefully in January. I'm looking at user
> page tables, PASID, dirty tracking and userspace IO fault handling as
> the main features iommufd must tackle.
> 
> The purpose of the sketches would be to validate that the HW features
> we want to exposed can work will with the choices the base is making.
> 
> Jason
