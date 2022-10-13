Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E8F5FDAD8
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJMN3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 09:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJMN3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 09:29:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B5A30F4B
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665667773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4KKY8/s+sQ9lr7rd7ALjTl6lLhXVb6v154EmyfSO0rM=;
        b=TIOhfn/n/3hHNe89xsklY1gYqXeN2STj8oJ30C+ax4+QQjNOuhjbvdQA0OZdNWsGt7Z2WZ
        U8GzJr8P4w6CmPhTXV1C6lbWrTYYH5H4AmpDZyMCkf5KO8iohjA0TegUPKY0nEOK7EJlWb
        udBskmWPFxCMuyMae5xqAop95E3wBcI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-644-XaZtdIejMt-yFk0rJeMK2Q-1; Thu, 13 Oct 2022 09:29:32 -0400
X-MC-Unique: XaZtdIejMt-yFk0rJeMK2Q-1
Received: by mail-wm1-f72.google.com with SMTP id h129-20020a1c2187000000b003bf635eac31so1176739wmh.4
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KKY8/s+sQ9lr7rd7ALjTl6lLhXVb6v154EmyfSO0rM=;
        b=z6ahjbahxIuXkpf3nduDp5410sUNPWKkaL6RtqRu0hLedOZqPo0l2Krb3mCLHA7h5j
         49CX+Kerd41c3cltqy8gDzVS8r0AnwuF5Hk2Umatrnq0z4vTrEe3EyqBBbkyhig2BPgz
         RET+nQddz+x97RcEGcehBJglCVqPMR6i5n+Ws8+mqds2KYyDAUS1N7NZfvWDvSRAw3eP
         DWO4kO+m/wM4yFOeV298sI5j/rHsJsFV9jYLkZqJmDnc973lz9Vnvb2Cg2SJSxZQ+ZAO
         BAlLKL9RK6VjkFxKP0PK2ebLBA4xuXBuKlyig2oAI8C2bbAw4781Vqz0WdJVjYlyZ/cw
         ljBw==
X-Gm-Message-State: ACrzQf1Bm9zIWfOYpqcgoOUwiY6bzQKCc1gmLsF0t+dI3t/XCWWUbUVH
        U0Yc9LUPpG915pToN8d3HAjDl00dMVgaQAf/TW9+zvM3bL/ePzcnbJCOD4wE5OfsG7WnPADuBVy
        FBhADBdTouKK3
X-Received: by 2002:adf:fdc6:0:b0:22e:373:939e with SMTP id i6-20020adffdc6000000b0022e0373939emr4289wrs.290.1665667769831;
        Thu, 13 Oct 2022 06:29:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7G8cHIkuPk67dNvD/drU7XrtQ67tQo7bcihxyTxwEo+LRIraZZPwGx0hx1u7GGcQ1E6azzsw==
X-Received: by 2002:adf:fdc6:0:b0:22e:373:939e with SMTP id i6-20020adffdc6000000b0022e0373939emr4275wrs.290.1665667769658;
        Thu, 13 Oct 2022 06:29:29 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id c17-20020adffb11000000b002305cfb9f3dsm2048230wrr.89.2022.10.13.06.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 06:29:29 -0700 (PDT)
Date:   Thu, 13 Oct 2022 14:29:27 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH 2/4] qemu-options.hx: Update the reduced-phys-bits
 documentation
Message-ID: <Y0gSt44XtIOLvioT@work-vm>
References: <cover.1664550870.git.thomas.lendacky@amd.com>
 <13a62ced1808546c1d398e2025cf85f4c94ae123.1664550870.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13a62ced1808546c1d398e2025cf85f4c94ae123.1664550870.git.thomas.lendacky@amd.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> A guest only ever experiences, at most, 1 bit of reduced physical
> addressing. Update the documentation to reflect this as well as change
> the example value on the reduced-phys-bits option.
> 
> Fixes: a9b4942f48 ("target/i386: add Secure Encrypted Virtualization (SEV) object")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  qemu-options.hx | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 913c71e38f..3396085cf0 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -5391,7 +5391,7 @@ SRST
>          physical address space. The ``reduced-phys-bits`` is used to
>          provide the number of bits we loose in physical address space.
>          Similar to C-bit, the value is Host family dependent. On EPYC,
> -        the value should be 5.
> +        a guest will lose a maximum of 1 bit, so the value should be 1.
>  
>          The ``sev-device`` provides the device file to use for
>          communicating with the SEV firmware running inside AMD Secure
> @@ -5426,7 +5426,7 @@ SRST
>  
>               # |qemu_system_x86| \\
>                   ...... \\
> -                 -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=5 \\
> +                 -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1 \\
>                   -machine ...,memory-encryption=sev0 \\
>                   .....
>  
> -- 
> 2.37.3
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

