Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8594C49DBF4
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 08:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiA0Hv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 02:51:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbiA0Hv0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 02:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643269885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GZX/pfOEsztdvqNPhksRj9ximKWEK/m51aO4OO9gIOw=;
        b=b7Jp4AcX3kuHQxt/Fk5erIL/0UiD5952SRoSIA7LKavxlHgr/qmBXNKI30Ag9x0NH7nSN+
        JaIlOmwGGHO0hjrxyUZJyCQW672B5XDVaiUJE3v2MQ9B+oFDwSiJrUObG+x1wDQuhmBPFK
        2ZCTfVMKyTfiagqs/sBR4qZm+6JHrME=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-mn7MAz0jMpa3xTDfx5jVKQ-1; Thu, 27 Jan 2022 02:51:24 -0500
X-MC-Unique: mn7MAz0jMpa3xTDfx5jVKQ-1
Received: by mail-ej1-f72.google.com with SMTP id l18-20020a1709063d3200b006a93f7d4941so961180ejf.1
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 23:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GZX/pfOEsztdvqNPhksRj9ximKWEK/m51aO4OO9gIOw=;
        b=8Oll2obdvpRlkmnTwPSC/DPyo/K9I6btO88am5iOso9UDnWWpvXOObLHTwcQx17vBv
         L+Tktx8ppcxREX7sazfUy+Oh35YFVSat91li8kLY9Zy0VwU/5VvDfMP6T+P3vjVush5V
         p7WIt3OLSf8oShYklnp32AXIb7NaTMcXujAgt0IeoMRY7wVs9cYMlcjibvmOGOgj98/D
         JNQ63BogkXLOaKv+dMBFBfRgGSYMNnGT7vMVRphmatNYqeFw5ZcKmu31WsJ/WAj9mbL2
         UF92raST1yUrx7v56//a79ecZM8WhNPqs0bvoTkUsoRwG61zhL3KUG875dkDfUoHG9sZ
         0WSQ==
X-Gm-Message-State: AOAM533uqtvzrWTAFl0cf0rgQNrYXENNkFoDWVgsGmcgAtl2TkZUkwfq
        6cKdVzzA+v6IZV7UtHaC74/USSiDtKe6CV7AwHb+H/+8PJbc6Sy3iu3wJQa69d2uTTL5Kq46Z+F
        pbAseQf1O4PgW
X-Received: by 2002:a17:907:7ba9:: with SMTP id ne41mr2137813ejc.554.1643269883097;
        Wed, 26 Jan 2022 23:51:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwG/4UQhcMKE386PoihoaUB7txnfoFbjmOGSKcgi5XKPa25Kh8n1GHpKiCaWiNcG0+jyHaPGA==
X-Received: by 2002:a17:907:7ba9:: with SMTP id ne41mr2137807ejc.554.1643269882938;
        Wed, 26 Jan 2022 23:51:22 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id g15sm10892632edy.77.2022.01.26.23.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:51:22 -0800 (PST)
Date:   Thu, 27 Jan 2022 08:51:20 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 5/5] kvm: selftests: aarch64: use a tighter assert in
 vgic_poke_irq()
Message-ID: <20220127075120.5ntwadlgf2ncd2ua@gator>
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-6-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127030858.3269036-6-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 07:08:58PM -0800, Ricardo Koller wrote:
> vgic_poke_irq() checks that the attr argument passed to the vgic device
> ioctl is sane. Make this check tighter by moving it to after the last
> attr update.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/aarch64/vgic.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> index 79864b941617..f365c32a7296 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -138,9 +138,6 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
>  	uint64_t val;
>  	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
>  
> -	/* Check that the addr part of the attr is within 32 bits. */
> -	assert(attr <= KVM_DEV_ARM_VGIC_OFFSET_MASK);
> -
>  	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
>  					  : KVM_DEV_ARM_VGIC_GRP_DIST_REGS;
>  
> @@ -150,6 +147,9 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
>  		attr += SZ_64K;
>  	}
>  
> +	/* Check that the addr part of the attr is within 32 bits. */
> +	assert((attr & ~KVM_DEV_ARM_VGIC_OFFSET_MASK) == 0);
> +
>  	/*
>  	 * All calls will succeed, even with invalid intid's, as long as the
>  	 * addr part of the attr is within 32 bits (checked above). An invalid
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

