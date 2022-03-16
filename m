Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977634DABF4
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 08:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344910AbiCPHpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 03:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354269AbiCPHpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 03:45:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18DDC55BE9
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 00:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647416641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mam8w85mLQbLuV3GPQ8EDdLw0BD02xApA60diEvmkn4=;
        b=TVRIhh2BszB8A6+/L+ObBJwK1gTU3gx61zmRpVLnpgBpS+R809QXKdX1A4xj5vZpVmVzDK
        RNXrwRC0VobicZqeoL20IIKopCq2gHltjlJ4ljuJgKTtpmnMK/AMoLjH0Ka8uBn0SK6se2
        tJG9M1YmBa3MhmEvBhnuhVVoi/b92gE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-V9ZvID4iOnm-zvjjQR0NcQ-1; Wed, 16 Mar 2022 03:43:59 -0400
X-MC-Unique: V9ZvID4iOnm-zvjjQR0NcQ-1
Received: by mail-wr1-f72.google.com with SMTP id z1-20020adfec81000000b001f1f7e7ec99so246644wrn.17
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 00:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mam8w85mLQbLuV3GPQ8EDdLw0BD02xApA60diEvmkn4=;
        b=I+siF04W/lSgh5JdyMVyyvrUk060YIeUeT1jy31Wb1LANRWt91LORDOp5p7bwvAq6G
         jlUmAxMUtvRL/LoKyOugc2V9ZgZYbwrHiZnKALc53lX07HZSLa37xNCfsDuqS8LNSsiU
         leR4Kz+L8ZX8IkuVmC1JIgqv8StB4dmMcLmFDTqXO3vkcRsvJggy+ZGPjVAatq73M/6+
         b+m6MixFM84XDMpBBR8biQvij79QdzQ4MzSwkchQY/Uuyaa2oY7HfrYJNHyA5APzyFwr
         KvXYhbosSXy5ow0MIdTVC/ZhOoiKoSZW2cI/6yGGYpL+LuRDpurdWIlir6W+EgJ2Qgle
         bZuQ==
X-Gm-Message-State: AOAM533UKWHKEud2Jxhelcv/wWJkDz055SuJybUDk+MyzN5XyjQ5ulqP
        lGnc3v0EUnPrvdHmbnQ8Sz5De4OUaSv7mUuetw7rcx8vizXIl3vWzVgDX+lrqburXXRhI/cgho0
        he0WvoVtWedZM
X-Received: by 2002:a05:6000:3c3:b0:203:6976:6942 with SMTP id b3-20020a05600003c300b0020369766942mr22674971wrg.584.1647416638728;
        Wed, 16 Mar 2022 00:43:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiO62Yr0EsUOjjzC1evZxOKsDkUVAOuXWop4OtVqEPPMKVE+73MXHoDL8nCf5FamNh4qQ6+g==
X-Received: by 2002:a05:6000:3c3:b0:203:6976:6942 with SMTP id b3-20020a05600003c300b0020369766942mr22674955wrg.584.1647416638514;
        Wed, 16 Mar 2022 00:43:58 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id u7-20020a5d6da7000000b00203d9d1875bsm984282wrs.73.2022.03.16.00.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 00:43:58 -0700 (PDT)
Date:   Wed, 16 Mar 2022 08:43:56 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        lvivier@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
Message-ID: <20220316074356.n7e5lzrmnal2dcgu@gator>
References: <20220316060214.2200695-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316060214.2200695-1-morbo@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

This is fixed in libfdt upstream with commit 7be250b4 ("libfdt:
Correct condition for reordering blocks"), which is in v1.6.1.
We can either take this patch as a backport of 7be250b4 or we
can rebase all of our libfdt to v1.6.1. Based on the number of
fixes in v1.6.1, which appear to be mostly for compiling with
later compilers, I'm in favor of rebasing.

Actually, we can also use this opportunity to [re]visit the
idea of changing libfdt to a git submodule. I'd like to hear
opinions on that.

Thanks,
drew

