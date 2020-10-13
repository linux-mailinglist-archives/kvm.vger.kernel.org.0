Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DDC28D63E
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 23:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgJMVci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 17:32:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728353AbgJMVci (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Oct 2020 17:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602624756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fk7xQQMQtblyklWfzN3PbY9/oXyJ1G6FiN83MbyUF4g=;
        b=LQqxUzwLxmr2zDjAOAJJg6GvcLTAGKXvPSuOxMtUKYUM6QARm12Pqt8z2Q7ZAsvBT2BxVk
        TMk5YQHlVBzp7TADXx9zi+3G7dVn4TBqTcDK4XpzDoEACQlMJb3Ru6MK+zFpUA+D5krna/
        Lcucf5Q7xTqC6Yw8AQ8qskOvYi8wlPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-R8Ach2HRP9KNwnMA_l1tuA-1; Tue, 13 Oct 2020 17:32:35 -0400
X-MC-Unique: R8Ach2HRP9KNwnMA_l1tuA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0C82801FD8;
        Tue, 13 Oct 2020 21:32:33 +0000 (UTC)
Received: from w520.home (ovpn-113-35.phx2.redhat.com [10.3.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11A885D9CD;
        Tue, 13 Oct 2020 21:32:29 +0000 (UTC)
Date:   Tue, 13 Oct 2020 15:32:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <song.bao.hua@hisilicon.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/platform: Replace spin_lock_irqsave by spin_lock
 in hard IRQ
Message-ID: <20201013153229.7fe74e65@w520.home>
In-Reply-To: <1602554458-26927-1-git-send-email-tiantao6@hisilicon.com>
References: <1602554458-26927-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Oct 2020 10:00:58 +0800
Tian Tao <tiantao6@hisilicon.com> wrote:

> It is redundant to do irqsave and irqrestore in hardIRQ context.

But this function is also called from non-IRQ context.  Thanks,

Alex
 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/vfio/platform/vfio_platform_irq.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index c5b09ec..24fd6c5 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -139,10 +139,9 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>  static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
>  {
>  	struct vfio_platform_irq *irq_ctx = dev_id;
> -	unsigned long flags;
>  	int ret = IRQ_NONE;
>  
> -	spin_lock_irqsave(&irq_ctx->lock, flags);
> +	spin_lock(&irq_ctx->lock);
>  
>  	if (!irq_ctx->masked) {
>  		ret = IRQ_HANDLED;
> @@ -152,7 +151,7 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
>  		irq_ctx->masked = true;
>  	}
>  
> -	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> +	spin_unlock(&irq_ctx->lock);
>  
>  	if (ret == IRQ_HANDLED)
>  		eventfd_signal(irq_ctx->trigger, 1);

