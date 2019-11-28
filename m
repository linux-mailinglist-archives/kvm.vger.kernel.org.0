Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8F910C64F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 11:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK1KCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 05:02:00 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58249 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726281AbfK1KB7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 05:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574935318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Ty42avADbFfsrksucy6eTvFgwCWCTZ2fGrRzoi90qU=;
        b=LUR0fsNvaLihiEvg3CVjhYyP0fmIe8ZlcN0SbR/uEuSUDTUZkIRPMfd4+xBpTfY/QpxMRX
        4pKbWU04Te7hg1sAP8HZo+S/RMr6qY8hXJQ78OsrO0zroJB6HlsDIBVx4meW1U5oJXvjQN
        SXIg/k1SNiErBU8Tx2wyw35mUH3yGNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-a2sGVNN_O46eQx4CcqBUVw-1; Thu, 28 Nov 2019 05:01:47 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74D1F1005510;
        Thu, 28 Nov 2019 10:01:46 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54D7210027B2;
        Thu, 28 Nov 2019 10:01:37 +0000 (UTC)
Subject: Re: [PATCH] vfio: call irq_bypass_unregister_producer() before
 freeing irq
To:     Jiang Yi <giangyi@amazon.com>, kvm@vger.kernel.org
Cc:     adulea@amazon.de, jschoenh@amazon.de, maz@kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com
References: <20191127164910.15888-1-giangyi@amazon.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <26ed9041-417c-199c-cb75-383b2200e89a@redhat.com>
Date:   Thu, 28 Nov 2019 11:01:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191127164910.15888-1-giangyi@amazon.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: a2sGVNN_O46eQx4CcqBUVw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 11/27/19 5:49 PM, Jiang Yi wrote:
> Since irq_bypass_register_producer() is called after request_irq(), we
> should do tear-down in reverse order: irq_bypass_unregister_producer()
> then free_irq().
> 
> Signed-off-by: Jiang Yi <giangyi@amazon.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 3fa3f728fb39..2056f3f85f59 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -289,18 +289,18 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
>  	int irq, ret;
>  
>  	if (vector < 0 || vector >= vdev->num_ctx)
>  		return -EINVAL;
>  
>  	irq = pci_irq_vector(pdev, vector);
>  
>  	if (vdev->ctx[vector].trigger) {
> -		free_irq(irq, vdev->ctx[vector].trigger);
>  		irq_bypass_unregister_producer(&vdev->ctx[vector].producer);
> +		free_irq(irq, vdev->ctx[vector].trigger);
Looks the right way too

Reviewed-by: Eric Auger <eric.auger@redhat.com>

May be worth checking it does not alter the x86 posted interrupt setup
though. update_pi_irte() gets called. I was concerned about the fact the
interrupts may be enabled when doing the unregistration (TBC). The
irq_bypass framework offers producer start/stop callbacks that would
allow to handle this but nobody use them atm.

Thanks

Eric
>  		kfree(vdev->ctx[vector].name);
>  		eventfd_ctx_put(vdev->ctx[vector].trigger);
>  		vdev->ctx[vector].trigger = NULL;
>  	}
>  
>  	if (fd < 0)
>  		return 0;
>  
> 

