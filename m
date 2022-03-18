Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0824DD728
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 10:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiCRJh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 05:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiCRJh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 05:37:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF3A42EA92E
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 02:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647596166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m4jF8/kC8zIHwAO3JdMD+H9wM977DPU+ZmNY1oF3jOo=;
        b=W0CJToXxsHVzafChRceYvf8ysJZz3XqEpa6DSQeIbHrGHGQ5HRq28UsOHYEAbiS8WEElnu
        JB5tj3C6Im0y8DUx/ItLQz8q7abmIu2FL09aWm95q7zNvPLeDHnonpGjcDO1eSGYJyjcQs
        kGFx4eXxV0x9+Iyzp71NcCJJ5kvZDeU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-xsEmWRwjMeqT0_e2niKZGg-1; Fri, 18 Mar 2022 05:36:05 -0400
X-MC-Unique: xsEmWRwjMeqT0_e2niKZGg-1
Received: by mail-ed1-f70.google.com with SMTP id w15-20020a50c44f000000b00418f00014f8so3465402edf.18
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 02:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m4jF8/kC8zIHwAO3JdMD+H9wM977DPU+ZmNY1oF3jOo=;
        b=gUd010iu86cLkh7Ox9T2AaSKUtkl2k1fPS9Hj5aetZAzhiucchlhSeklkwHqtOf61o
         l43MZ6MFtD2qOqNm2uIDvpatmj9A+MdYC+1PrzcetJ7i0J/7/XLbcVkIKmyg8nU62A4u
         MEuQXWsiOEQwXS13bfCNBXLSgLOHwlSi1qGHncLgxL7zfISItwgV7mpAkiWO7SEmuHRb
         g79GwDRsia3e4vg3A7HTdBa2hvuFsMuu+1p9r67lDy/lhMFVSsMip0smxMK2dfYnX3m/
         13q9LKmNOTsGdwTTRKQR6MFWc1Y7Pzedly3xHoGW3IUx67Wu3Thqiw2MLAwQhA/3Y6q3
         6GUA==
X-Gm-Message-State: AOAM532pBUmwx1SvMPdQDP+OkpvUYG0Ii3BByxrC4P6+rI5u++6Ium/7
        aUvj8iSZHOT9r+gRWJvC+fNGz+jGLELelUhSKwGeWyDaDq+P95Hs9cZv/6OMYaovsrLgW68eRiq
        QwzT0HR8DhOsO
X-Received: by 2002:a17:906:4c83:b0:6b7:b321:5d54 with SMTP id q3-20020a1709064c8300b006b7b3215d54mr7986226eju.676.1647596164179;
        Fri, 18 Mar 2022 02:36:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGfngiAJB91ib0NSDhnemNwcbBdY9hFIPe7Ws8dqmHZ+SkhiUDTGSr3KrMjxf9cL0cYbqRvw==
X-Received: by 2002:a17:906:4c83:b0:6b7:b321:5d54 with SMTP id q3-20020a1709064c8300b006b7b3215d54mr7986200eju.676.1647596163934;
        Fri, 18 Mar 2022 02:36:03 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id sg9-20020a170907a40900b006df8c6df89fsm2355398ejc.93.2022.03.18.02.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 02:36:03 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:36:01 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, alexandru.elisei@arm.com,
        thuth@redhat.com, suzuki.poulose@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
Message-ID: <20220318093601.zqhuzrp2ujgswsiw@gator>
References: <20220316060214.2200695-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316060214.2200695-1-morbo@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 11:02:14PM -0700, Bill Wendling wrote:
> Clang warns about using a bitwise '|' with boolean operands. This seems
> to be due to a small typo.
> 
>   lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>           if (can_assume(LIBFDT_ORDER) |
> 
> Using '||' removes this warnings.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/libfdt/fdt_rw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
> index 13854253ff86..3320e5559cac 100644
> --- a/lib/libfdt/fdt_rw.c
> +++ b/lib/libfdt/fdt_rw.c
> @@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
>  			return struct_size;
>  	}
>  
> -	if (can_assume(LIBFDT_ORDER) |
> +	if (can_assume(LIBFDT_ORDER) ||
>  	    !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
>  		/* no further work necessary */
>  		err = fdt_move(fdt, buf, bufsize);
> -- 
> 2.35.1.723.g4982287a31-goog
>

We're not getting as much interest in the submodule discussion as I hoped.
I see one vote against on this thread and one vote for on a different
thread[1]. For now I'll just commit a big rebase patch for libfdt. We can
revisit it again after we decide what to do for QCBOR.

Thanks,
drew

[1] https://lore.kernel.org/kvm/20220316105109.oi5g532ylijzldte@gator/T/#m48c47c761f3b3a4da636482b6385c59d4a990137 

