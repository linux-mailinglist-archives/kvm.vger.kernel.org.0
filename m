Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE82A4E36
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgKCSSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:18:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725385AbgKCSSG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 13:18:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604427485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/BtiNbA7S+imU9r9wm1tSfzmZPhlyYiVJn61vXEcUAk=;
        b=fBiyyO+qfjT8aqNZGL1oCtJTwjCmgeAldb+TDVIPpRUa0aid0iEvfRSdG+93EE/odJ9JZS
        UTmqH1Xz68ToDyQLT9tTPR1TZibWCxbuw1LiotA8221dGqrQWLVNxlZYHeM/qXERSECuBF
        yGhitdOXWII6rFRpiFDwPhLuGjWBw64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-FGuLZy7WN2CZnQz0TuOyWw-1; Tue, 03 Nov 2020 13:18:04 -0500
X-MC-Unique: FGuLZy7WN2CZnQz0TuOyWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B42231868412;
        Tue,  3 Nov 2020 18:18:02 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60B3110013C1;
        Tue,  3 Nov 2020 18:18:02 +0000 (UTC)
Date:   Tue, 3 Nov 2020 11:18:01 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH] vfio/type1: Use the new helper to find vfio_group
Message-ID: <20201103111801.05d4cee5@w520.home>
In-Reply-To: <20201022122417.245-1-yuzenghui@huawei.com>
References: <20201022122417.245-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 20:24:17 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> When attaching a new group to the container, let's use the new helper
> vfio_iommu_find_iommu_group() to check if it's already attached. There
> is no functional change.
> 
> Also take this chance to add a missing blank line.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)


Applied to vfio for-linus branch for v5.10.  Thanks,

Alex

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a05d856ae806..aa586bd684da 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1997,6 +1997,7 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
>  
>  	list_splice_tail(iova_copy, iova);
>  }
> +
>  static int vfio_iommu_type1_attach_group(void *iommu_data,
>  					 struct iommu_group *iommu_group)
>  {
> @@ -2013,18 +2014,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  
>  	mutex_lock(&iommu->lock);
>  
> -	list_for_each_entry(d, &iommu->domain_list, next) {
> -		if (find_iommu_group(d, iommu_group)) {
> -			mutex_unlock(&iommu->lock);
> -			return -EINVAL;
> -		}
> -	}
> -
> -	if (iommu->external_domain) {
> -		if (find_iommu_group(iommu->external_domain, iommu_group)) {
> -			mutex_unlock(&iommu->lock);
> -			return -EINVAL;
> -		}
> +	/* Check for duplicates */
> +	if (vfio_iommu_find_iommu_group(iommu, iommu_group)) {
> +		mutex_unlock(&iommu->lock);
> +		return -EINVAL;
>  	}
>  
>  	group = kzalloc(sizeof(*group), GFP_KERNEL);

