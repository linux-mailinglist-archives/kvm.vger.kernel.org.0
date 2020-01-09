Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C97135A8A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 14:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbgAINuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 08:50:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20730 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728435AbgAINuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 08:50:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578577816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=liWaVRDkB7M/NIE/+cSTxCodggadqfblBOKnqAK6Nlw=;
        b=D02OC3TLr3mX10brouzSRYyd59t0zCW27bwwLL0GLbmla9WhGxH30Eo+KdUZ812BGZW+j0
        m/JB5HQ1gqwvz79HSCC0IY7zTGxBUt1b1Rr2qkaaRD2/pDaBSpCduea6m6r38dNoxjTkRC
        jWsxc3VHMhzCj/SAdQ8YjchT6rNSoJU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-QKk7WamINZS_Pf35vJUnfQ-1; Thu, 09 Jan 2020 08:50:12 -0500
X-MC-Unique: QKk7WamINZS_Pf35vJUnfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAA4F801E6C;
        Thu,  9 Jan 2020 13:50:11 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74EFA5C3FA;
        Thu,  9 Jan 2020 13:50:08 +0000 (UTC)
Date:   Thu, 9 Jan 2020 14:50:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: check if kernel irqchip is actually enabled
Message-ID: <20200109145006.21f0a065.cohuck@redhat.com>
In-Reply-To: <20200109134713.14755-1-cohuck@redhat.com>
References: <20200109134713.14755-1-cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Jan 2020 14:47:13 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On s390, we only allow userspace to create an in-kernel irqchip
> if it has first enabled the KVM_CAP_S390_IRQCHIP vm capability.
> Let's assume that a userspace that enabled that capability has
> created an irqchip as well.
> 
> Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
> 
> A more precise check would be to add a field in kvm_arch that tracks
> whether an irqchip has actually been created; not sure if that is
> really needed.
> 
> Found while trying to hunt down QEMU crashes with kvm-irqchip=off;

s/kvm-irqchip/kernel_irqchip/

> this is not sufficient, though. I *think* everything but irqfds
> should work without kvm-irqchip as well, but have not found the problem
> yet.
> 
> ---
>  arch/s390/kvm/irq.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/irq.h b/arch/s390/kvm/irq.h
> index 484608c71dd0..30e13d031379 100644
> --- a/arch/s390/kvm/irq.h
> +++ b/arch/s390/kvm/irq.h
> @@ -13,7 +13,7 @@
>  
>  static inline int irqchip_in_kernel(struct kvm *kvm)
>  {
> -	return 1;
> +	return !!kvm->arch.use_irqchip;
>  }
>  
>  #endif

