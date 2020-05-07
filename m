Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929601C9D39
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 23:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgEGVYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 17:24:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23930 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726218AbgEGVYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 17:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588886688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+hf8+llPyWbESgzeV9oWGjfToVmGFDxL774OpBs4NOI=;
        b=hO1xxG7lElaKlNqw8JW+pem8vY1uJBJgtDGUMvJaiS7my9qdTwksfRHeDci3JHfOI5/Hcp
        SidvvUrlI6aM1HkkXiiIa4JIwhqUhn+137iw+PqLBFx+ryerXtmWJkNTsOQPvHS5BWGYwD
        SG6nL73t4dEM1kNDe5jWDvygzaGhA1o=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-F2pTXX8RPJKBOLQxFv1vGQ-1; Thu, 07 May 2020 17:24:46 -0400
X-MC-Unique: F2pTXX8RPJKBOLQxFv1vGQ-1
Received: by mail-qv1-f69.google.com with SMTP id m20so7225327qvy.13
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 14:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+hf8+llPyWbESgzeV9oWGjfToVmGFDxL774OpBs4NOI=;
        b=Ta+jrsqT0IW/u0qBAutpgA6SkDz1hLS8qON61Oybvmh9v8pmP7CoLbONpziKvwUCW4
         YglVYuVgmE2YjbtEu6zhaSZwLM2d+t3QmcAoXBAcPj2fZscr+XKG/XtPPp2Gz5jPrbAx
         73HxC+RauSf/OyxwgIC/GUqysIzJMFWRYoNnXo+xfIIcUczjaU3kKt1xX5wKT+Ue2Kzi
         TbocKx6CKbIiO1ejmDVqAMunC9JLur8FsjQ2WtvP/z8nr79zx+joQp3a0bRJZ+gt2iYj
         aL9gkCSU7y5Klp9f6uhHrYQELW15C4XcKhmzcrTGjTM99kQ6KPgLsr0T8z7gDiXfIK+9
         vaGg==
X-Gm-Message-State: AGi0PuYO8sH+k3Y9Ah/hV4f+OM6+hcFVdfFOCZR3N++ZsPC3iXouhRul
        hzLOU26tm9yuGwxNj2gr16av4QwCiXbQJ3aHsJF3HtjicyyfPaufYdBy/NCRLtVd57jC27nUu3/
        z/bXu/w6IESHq
X-Received: by 2002:a05:6214:287:: with SMTP id l7mr15289603qvv.38.1588886686037;
        Thu, 07 May 2020 14:24:46 -0700 (PDT)
X-Google-Smtp-Source: APiQypIYk2Q7XtkMJpVDHjFh9SbqkSsjahcyPlqUXryygjPQkw6M3+HDsdemXyYJU+pQXbjJup5B6w==
X-Received: by 2002:a05:6214:287:: with SMTP id l7mr15289582qvv.38.1588886685719;
        Thu, 07 May 2020 14:24:45 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l2sm5231724qkd.57.2020.05.07.14.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 14:24:44 -0700 (PDT)
Date:   Thu, 7 May 2020 17:24:43 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200507212443.GO228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871568480.15589.17339878308143043906.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <158871568480.15589.17339878308143043906.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 03:54:44PM -0600, Alex Williamson wrote:
> With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> the range being faulted into the vma.  Add support to manually provide
> that, in the same way as done on KVM with hva_to_pfn_remapped().
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
>  1 file changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index cc1d64765ce7..4a4cb7cd86b2 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
>  	return 0;
>  }
>  
> +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> +			    unsigned long vaddr, unsigned long *pfn,
> +			    bool write_fault)
> +{
> +	int ret;
> +
> +	ret = follow_pfn(vma, vaddr, pfn);
> +	if (ret) {
> +		bool unlocked = false;
> +
> +		ret = fixup_user_fault(NULL, mm, vaddr,
> +				       FAULT_FLAG_REMOTE |
> +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> +				       &unlocked);
> +		if (unlocked)
> +			return -EAGAIN;

Hi, Alex,

IIUC this retry is not needed too because fixup_user_fault() will guarantee the
fault-in is done correctly with the valid PTE as long as ret==0, even if
unlocked==true.

Note: there's another patch just removed the similar retry in kvm:

https://lore.kernel.org/kvm/20200416155906.267462-1-peterx@redhat.com/

Thanks,

> +
> +		if (ret)
> +			return ret;
> +
> +		ret = follow_pfn(vma, vaddr, pfn);
> +	}
> +
> +	return ret;
> +}

-- 
Peter Xu

