Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AA8131C0E
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 00:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbgAFXFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 18:05:16 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37429 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727299AbgAFXFQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 18:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578351915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLKjgSS54aTHzXEfXpX12lWPHXAZTNlNIdeozIHoPjY=;
        b=AnKluiEGA/Jxlye80QPwkzTqb1zMfdQDR+Rxo+Flq+6VEnozg2gJyD9eUDxlIujBZUJ0Du
        EKoHL0+/zdiQw1QVLD6NSuK7+RAqYhDpRuQ5eVBYZNcTcKR3tJRZp/i9RQEcTdgGoyIbz1
        +29EbPyfESV3E7UrbJHIi0tB3Y0O4LQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-Dg1E0E9hODeNjj_K04rBgA-1; Mon, 06 Jan 2020 18:05:09 -0500
X-MC-Unique: Dg1E0E9hODeNjj_K04rBgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DA1D1005510;
        Mon,  6 Jan 2020 23:05:08 +0000 (UTC)
Received: from w520.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E28167C82C;
        Mon,  6 Jan 2020 23:05:07 +0000 (UTC)
Date:   Mon, 6 Jan 2020 16:05:07 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kernel-janitors@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] vfio/spapr_tce: use mmgrab
Message-ID: <20200106160507.3fc1712a@w520.home>
In-Reply-To: <1577634178-22530-4-git-send-email-Julia.Lawall@inria.fr>
References: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr>
        <1577634178-22530-4-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 29 Dec 2019 16:42:57 +0100
Julia Lawall <Julia.Lawall@inria.fr> wrote:

> Mmgrab was introduced in commit f1f1007644ff ("mm: add new mmgrab()
> helper") and most of the kernel was updated to use it. Update a
> remaining file.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> <smpl>
> @@ expression e; @@
> - atomic_inc(&e->mm_count);
> + mmgrab(e);
> </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/vfio/vfio_iommu_spapr_tce.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 26cef65b41e7..16b3adc508db 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -79,7 +79,7 @@ static long tce_iommu_mm_set(struct tce_container *container)
>  	}
>  	BUG_ON(!current->mm);
>  	container->mm = current->mm;
> -	atomic_inc(&container->mm->mm_count);
> +	mmgrab(container->mm);
>  
>  	return 0;
>  }
> 

Acked-by: Alex Williamson <alex.williamson@redhat.com>

