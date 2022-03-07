Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890BB4CFC0C
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 11:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbiCGK61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 05:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241727AbiCGK5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 05:57:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAFF59FCC
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 02:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646648416;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=a5r/9Ad9M4LC+CnWwnf0WKIHJ37oVkohITJ/B7EDyPw=;
        b=hrjwSuz+yF1xmyJGpGMA4IYxFH+8wCMYtqpbWo8NeK4jwNfPR+vRRhe8A504DvD8o3NwpX
        u6N7HMKzyq3TSRKbGQw6QNCyOUL1FJAwtPoe1gWDu4ZO1j3jW+ytwfnfJG5kQ24bgYpdor
        OEBg9nvntiB4ha3UzDUgOAVg7OkR1KA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-Kmbl2nckOhSSUSjOxrbFuQ-1; Mon, 07 Mar 2022 05:20:12 -0500
X-MC-Unique: Kmbl2nckOhSSUSjOxrbFuQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAA09801AFC;
        Mon,  7 Mar 2022 10:20:11 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CB1E8089A;
        Mon,  7 Mar 2022 10:20:10 +0000 (UTC)
Date:   Mon, 7 Mar 2022 10:20:07 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Tyler Fanelli <tfanelli@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3] i386/sev: Ensure attestation report length is valid
 before retrieving
Message-ID: <YiXcV3ObOJulovnN@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220304201141.509492-1-tfanelli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220304201141.509492-1-tfanelli@redhat.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022 at 03:11:43PM -0500, Tyler Fanelli wrote:
> The length of the attestation report buffer is never checked to be
> valid before allocation is made. If the length of the report is returned
> to be 0, the buffer to retrieve the attestation buffer is allocated with
> length 0 and passed to the kernel to fill with contents of the attestation
> report. Leaving this unchecked is dangerous and could lead to undefined
> behavior.
> 
> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> ---
>  target/i386/sev.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 025ff7a6f8..e82be3e350 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -616,6 +616,8 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>          return NULL;
>      }
>  
> +    input.len = 0;
> +
>      /* Query the report length */
>      ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
>              &input, &err);
> @@ -626,6 +628,11 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
>                         ret, err, fw_error_to_str(err));
>              return NULL;
>          }
> +    } else if (input.len == 0) {
> +        error_setg(errp, "SEV: Failed to query attestation report:"
> +                         " length returned=%u",
> +                   input.len);
> +        return NULL;

I still feel the described scenario is a kernel bug, as QEMU handles
len == 0 safely already AFAICT. I can't see how the upstream kernel
would end up in the problem state. Can you show the buggy kernel
code upstream.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

