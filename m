Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB8F209CFA
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 12:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404038AbgFYKlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 06:41:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34233 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404000AbgFYKlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 06:41:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593081667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vllVC2Cgz99U4g4CTF9C3PsHuHaj3GajD97wMzhY5bY=;
        b=bv8xKO7pSLCt7yEV8KKnw+GPuEmJUWKQUDioZkicDZSbjTljv0I7dQQOMUn228jF9sDanC
        Y51OeMi3tF/eit6eTAc21esO78KxR/B/52iNA8WoPEBaCgnqMhd1YaZatmyumdj/fFU2qL
        A9VEMx5I6ZbiXvchfx/F2y56vC42EZg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-bcEj0bjZOJ6AjP3hILlpHQ-1; Thu, 25 Jun 2020 06:41:05 -0400
X-MC-Unique: bcEj0bjZOJ6AjP3hILlpHQ-1
Received: by mail-wm1-f69.google.com with SMTP id t145so6786050wmt.2
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 03:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vllVC2Cgz99U4g4CTF9C3PsHuHaj3GajD97wMzhY5bY=;
        b=p6blBxxSFSOLK5kXka7zoH45xdm54rBdfXxOQL8OlQHRCGHVEwjbLFFP9GWahfHvbN
         VAwzwngTggYFOWe50u1PZvdnC6GBiWTE0B1CCgy5YHTYl2eEMPsTrAWQszhSLum+NmvX
         dfOWyNifMbqL2PjeM+Pmphz4dMpTHhUBcRiYicRs9DmMeOywCmO5Uc7P+p6ElbcBf6d7
         pKPKLpPWisKWqKCBBwZHeWpTqR0ZBIanotdVJUVV77RySGa1kCKREFDpNwpYp5yQNh6+
         S8uo7LUjYowtDJQO7dygmwmWaE2ml1kvoFLP0rF7vmAbtQ/5soqdPm8oIUU8GTjFCi6N
         Zeug==
X-Gm-Message-State: AOAM533moVsyRvx611OwF8ZzH+3z5K+1AhOEuvxtI2CfRX76CEQum1a1
        vPEb81l6lcJuAc1ex/Rw4ttrKZxz+NwO8JlIOlOm/nwR8IC6px+r9sFOynxoeU8zmDozGcow2uZ
        TVTIMuStMX+jF
X-Received: by 2002:a1c:8117:: with SMTP id c23mr2528267wmd.157.1593081663791;
        Thu, 25 Jun 2020 03:41:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzulRZXeVwT8x2psHA44QZMKK4kBMbdv8sAotTGwsRljA7T1Iw/0PADkYooEvKx/7DiBpn3CA==
X-Received: by 2002:a1c:8117:: with SMTP id c23mr2528247wmd.157.1593081663596;
        Thu, 25 Jun 2020 03:41:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91d0:a5f0:9f34:4d80? ([2001:b07:6468:f312:91d0:a5f0:9f34:4d80])
        by smtp.gmail.com with ESMTPSA id r3sm243165wmh.36.2020.06.25.03.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 03:41:03 -0700 (PDT)
Subject: Re: [PATCH] x86: fix smp_stacktop on 32-bit
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200624203602.44659-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4ffe112-44af-3ee7-94f8-90edd8e3841b@redhat.com>
Date:   Thu, 25 Jun 2020 12:41:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200624203602.44659-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/20 22:36, Nadav Amit wrote:
> smp_stacktop in 32-bit is fixed to some magic address. Use the address
> of the memory that was reserved for the stack instead.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/cstart.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index 1d8b8ac..a072aed 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -134,7 +134,7 @@ prepare_32:
>  	mov %eax, %cr0
>  	ret
>  
> -smp_stacktop:	.long 0xa0000
> +smp_stacktop:	.long stacktop - 4096
>  
>  save_id:
>  	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
> 

Queued, thanks.

Paolo

