Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3734201610
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389565AbgFSQZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 12:25:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394500AbgFSQZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 12:25:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592583942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4/8VCopb3LdQ9ocweieILvQnki01VB3cFX0hwScVkE=;
        b=AQZ8jG5EL9mm+ZXzP4BgNMMO7QL8i5a4jRE4XEPwbkMYtTqUYOaaEivlcu56G3SmNO4neO
        F/zOEejP/P5QNYxyulScE8kfbi3DtJBeA4qLXgDUwE+yu3ebGniuQ9Bi3X7P3vUeYgjmF2
        Gf0FaHOAE9TSN14kjW3BwFlOzj0SerE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-suLAiTx1MdqbufDtdkazBA-1; Fri, 19 Jun 2020 12:25:40 -0400
X-MC-Unique: suLAiTx1MdqbufDtdkazBA-1
Received: by mail-wm1-f71.google.com with SMTP id r1so4146816wmh.7
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 09:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d4/8VCopb3LdQ9ocweieILvQnki01VB3cFX0hwScVkE=;
        b=Rz9GgCvO9LnKmDpr/osYZJjoIY0zIdlSvDR6dPeCxVhMDZPoqUY/Pz7fGKtG+NYGUt
         QWSG0lW6mieEn5Md984ZAwM9ELxZPkSqBwJzYZCWXTj1EyNxqQRSej6G56qOAXwJqY0P
         8OlXoFnIbRusUiHX6Clo4ch5jPKfO6U7Aao+fX56DHhEP4cuBYhUWaVPPWo3ZYQqgF06
         RKJ2tfgQ6Vjgy00YPNvmP/6ErG+lQrhL+EEOiTT63vSzZarWOWoNuifSUewMkjkM1yXU
         CnSUMNK0r6YTTdABbw007uiC23cOyB9QWQz3Mye1fQutTX7hyLe8WvemlrYurW2ZfQ0K
         qITg==
X-Gm-Message-State: AOAM530qSaICEw46y0ir3kq/PBwUtdZjTYBKCFZvJwmafpIKKmVDeYYB
        kEVCyXNln85MyLjolAMcxdCAICar7XzP3dYiH8ierU+BJfr2Y9t02k9s0bSWToCZqqL7XqzqZhW
        zbyJgat6yS3Yc
X-Received: by 2002:a5d:420b:: with SMTP id n11mr4940572wrq.91.1592583939415;
        Fri, 19 Jun 2020 09:25:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEraKPOsYCSAzhCsDeOFjFxRKxDlDU5aMy0+GNkW9QCjiKMhv/0CQexC/WpvLK6AoKsXhEwg==
X-Received: by 2002:a5d:420b:: with SMTP id n11mr4940548wrq.91.1592583939177;
        Fri, 19 Jun 2020 09:25:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id u4sm8039969wmb.48.2020.06.19.09.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 09:25:38 -0700 (PDT)
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
To:     Mohammed Gamal <mgamal@redhat.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        kvm@vger.kernel.org
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9a6f8448-a7d9-9f1d-315d-2ca611ff4dbe@redhat.com>
Date:   Fri, 19 Jun 2020 18:25:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200619155344.79579-3-mgamal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/20 17:53, Mohammed Gamal wrote:
> If the CPU doesn't support GUEST_MAXPHYADDR < HOST_MAXPHYADDR we
> let QEMU choose to use the host MAXPHYADDR and print a warning to the
> user.
> 
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  target/i386/cpu.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b1b311baa2..91c57117ce 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6589,6 +6589,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>              uint32_t host_phys_bits = x86_host_phys_bits();
>              static bool warned;
>  
> +	    /*
> +	     * If host doesn't support setting physical bits on the guest,
> +	     * report it and return
> +	     */
> +	    if (cpu->phys_bits < host_phys_bits &&
> +		!kvm_has_smaller_maxphyaddr()) {
> +		warn_report("Host doesn't support setting smaller phys-bits."
> +			    " Using host phys-bits\n");
> +		cpu->phys_bits = host_phys_bits;
> +	    }
> +
>              /* Print a warning if the user set it to a value that's not the
>               * host value.
>               */
> 

You should remove the existing warning too.

Paolo

