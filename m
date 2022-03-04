Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E034B4CDD1E
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiCDTGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCDTGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:06:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 145EA1DDFE0
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 11:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646420731;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=QsEZdECL9CO/8Rbo/YAaICdmr+wHlhPaRNfeTYH5570=;
        b=CXISUZwDlJLwhWACLb8Eyu4AsiF/DE9g0WUCYCzgDimA4ob4RKnEiVkMNfD4pTpQs4KrFw
        B3EMk4PIpTDwgzxQ53R1QaMJCDn5/YBSJ+j/UkqBM6AQZuoEFUNOT9GrpYzhnRrAC/Kmao
        V7gTbpOwhizhAHjDoqy9CH5iDJX3MZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-OIWayi5wNH2UNMu7atr7PA-1; Fri, 04 Mar 2022 14:05:29 -0500
X-MC-Unique: OIWayi5wNH2UNMu7atr7PA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1138A1006AA7;
        Fri,  4 Mar 2022 19:05:29 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44F1110016F2;
        Fri,  4 Mar 2022 19:05:27 +0000 (UTC)
Date:   Fri, 4 Mar 2022 19:05:24 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Tyler Fanelli <tfanelli@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH] i386/sev: Ensure attestation report length is valid
 before retrieving
Message-ID: <YiJi9IYqtZvNQIRc@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220304183930.502777-1-tfanelli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220304183930.502777-1-tfanelli@redhat.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022 at 01:39:32PM -0500, Tyler Fanelli wrote:
> The length of the attestation report buffer is never checked to be
> valid before allocation is made. If the length of the report is returned
> to be 0, the buffer to retrieve the attestation report is allocated with
> length 0 and passed to the kernel to fill with contents of the attestation
> report. Leaving this unchecked is dangerous and could lead to undefined
> behavior.

I don't see the undefined behaviour risk here.

The KVM_SEV_ATTESTATION_REPORT semantics indicate that the kernel
will fill in a valid length if the buffer we provide is too small
and we can re-call with that buffer.

If the kernel tells us the buffer is 0 bytes, then it should be
fine having a second call with length 0. If not, then the kernel
is broken and we're doomed.

The QEMU code looks like it would cope with a zero length, unless
I'm mistaken, it'll  just return a zero length attestation report.

> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> ---
>  target/i386/sev.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 025ff7a6f8..215acd7c6b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -616,6 +616,8 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>          return NULL;
>      }
>  
> +    input.len = 0;

The declaration of 'input' already zero initializes.

>      /* Query the report length */
>      ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
>              &input, &err);
> @@ -626,6 +628,11 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>                         ret, err, fw_error_to_str(err));
>              return NULL;
>          }
> +    } else if (input.len <= 0) {

It can't be less than 0 because 'len' is an unsigned integer.

> +        error_setg(errp, "SEV: Failed to query attestation report:"
> +                         " length returned=%d",
> +                   input.len);
> +        return NULL;
>      }



Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

