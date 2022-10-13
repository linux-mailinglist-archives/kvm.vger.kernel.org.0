Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5371F5FDAE4
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 15:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJMNbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 09:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiJMNbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 09:31:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9D0357FD
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665667877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Aw9adUFB/juzsqoumphcPYb990OVAX41oP8SwYKW3KQ=;
        b=htHm9Ui9w7OTCD1Y6Cor/ujo0UN1Skmc14bh0XDendmnVJypGSIu+7wxb5UKM00VpQEtms
        Q90x0iHsuL31Yi7kBApy9PLlGJRFdRue5DHcK5KSehewSvI3MJhInK9u9s3lv6wUFiW6F/
        l5N6eK0s+TKyEY2TBWwdaHheYs3AA+s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-304-SR7O6Z2kNHaXUIQ_pxr4ig-1; Thu, 13 Oct 2022 09:31:16 -0400
X-MC-Unique: SR7O6Z2kNHaXUIQ_pxr4ig-1
Received: by mail-wm1-f70.google.com with SMTP id l1-20020a7bc341000000b003bfe1273d6cso834043wmj.4
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:31:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aw9adUFB/juzsqoumphcPYb990OVAX41oP8SwYKW3KQ=;
        b=0VHca1qgr+yp05CehKSoOXVixwu+oh7NKr7oIHOp+C4wOkBGDgegreQBZ+1lze0qoY
         Iy3RG0ftGGg98/vBQxoq6TtUMy5AzxpPfKjjPXfmgUnsOhQ6gDofCNDJVJdrb6U33WN8
         lRGD+osek3P3ucj8zEfqch9C8O5RVZUOrJt/UhlJJi5BfaLO/6LhmwgLYHOx0Juzh72N
         vJRL2+PI1Y5G+Q2RfWnYI5lbGyMqf5gbWFk+0pdh9bycrDBieB8M9S9GoOv7RVhESvdH
         OZhQg0Qbq6r7lMc4cZPd/zXbv1HhYP2Khs9Lt0f9qzqlmQvoybfYxZekTajPHSE2La0h
         d+2g==
X-Gm-Message-State: ACrzQf2sOMQvJrrOhFnmmG2nLFiGUp7BVphnuC/FKtxBsTx3KWKk1QW1
        ohaNesrE3gPZ55PEQNR+T7pPAI2Ke/zGeiw+CEZMR6iL/xKjMSnHq75aCN7D/k4dluAftRSE4KH
        u3WdI48bIZ4M3
X-Received: by 2002:a05:600c:2219:b0:3c4:cf31:8a13 with SMTP id z25-20020a05600c221900b003c4cf318a13mr6582347wml.122.1665667874990;
        Thu, 13 Oct 2022 06:31:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7CU6hVSgwnUbjb0jsk7uAS5VvzrK3DptOzeRSw9zcV93zR9/Mmt/HG5Jjk7LyGJOGa3iT4sA==
X-Received: by 2002:a05:600c:2219:b0:3c4:cf31:8a13 with SMTP id z25-20020a05600c221900b003c4cf318a13mr6582333wml.122.1665667874816;
        Thu, 13 Oct 2022 06:31:14 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id iv20-20020a05600c549400b003b4c40378casm5000447wmb.39.2022.10.13.06.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 06:31:14 -0700 (PDT)
Date:   Thu, 13 Oct 2022 14:31:12 +0100
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
Subject: Re: [PATCH 3/4] i386/sev: Update checks and information related to
 reduced-phys-bits
Message-ID: <Y0gTICvjTDUd8Oqw@work-vm>
References: <cover.1664550870.git.thomas.lendacky@amd.com>
 <cca5341a95ac73f904e6300f10b04f9c62e4e8ff.1664550870.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cca5341a95ac73f904e6300f10b04f9c62e4e8ff.1664550870.git.thomas.lendacky@amd.com>
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
> The value of the reduced-phys-bits parameter is propogated to the CPUID
> information exposed to the guest. Update the current validation check to
> account for the size of the CPUID field (6-bits), ensuring the value is
> in the range of 1 to 63.
> 
> Maintain backward compatibility, to an extent, by allowing a value greater
> than 1 (so that the previously documented value of 5 still works), but not
> allowing anything over 63.
> 
> Fixes: d8575c6c02 ("sev/i386: add command to initialize the memory encryption context")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  target/i386/sev.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 32f7dbac4e..78c2d37eba 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -932,15 +932,26 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
>      host_cbitpos = ebx & 0x3f;
>  
> +    /*
> +     * The cbitpos value will be placed in bit positions 5:0 of the EBX
> +     * register of CPUID 0x8000001F. No need to verify the range as the
> +     * comparison against the host value accomplishes that.
> +     */
>      if (host_cbitpos != sev->cbitpos) {
>          error_setg(errp, "%s: cbitpos check failed, host '%d' requested '%d'",
>                     __func__, host_cbitpos, sev->cbitpos);
>          goto err;
>      }
>  
> -    if (sev->reduced_phys_bits < 1) {
> -        error_setg(errp, "%s: reduced_phys_bits check failed, it should be >=1,"
> -                   " requested '%d'", __func__, sev->reduced_phys_bits);
> +    /*
> +     * The reduced-phys-bits value will be placed in bit positions 11:6 of
> +     * the EBX register of CPUID 0x8000001F, so verify the supplied value
> +     * is in the range of 1 to 63.
> +     */
> +    if (sev->reduced_phys_bits < 1 || sev->reduced_phys_bits > 63) {
> +        error_setg(errp, "%s: reduced_phys_bits check failed,"
> +                   " it should be in the range of 1 to 63, requested '%d'",
> +                   __func__, sev->reduced_phys_bits);
>          goto err;
>      }
>  
> -- 
> 2.37.3
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

