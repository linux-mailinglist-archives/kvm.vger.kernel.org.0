Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006F3534F9A
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 14:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbiEZMtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 08:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiEZMtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 08:49:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B01931C136
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 05:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653569358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S+74WIiIqDeXpjtoAD/TEU28DZze6OAJ67hCvQbNFLU=;
        b=hanH4p9U0iUUxbLxCQkO2hLbAu0YM/OOWVKRKBrX4bngL7LO4mcQWrMIS2CbhHSndq8DiS
        WlNPvEnf5hr6lvY+foZ/o+RG8JAAplSXRwm/O38/nCNfd5VZBD/QC29yWFD6NZ8rjCByPK
        idATMO24P7uCtvs4R5kTwbUfERCIpEQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-7KKPy_nbNKe80ni1_V5aHQ-1; Thu, 26 May 2022 08:49:17 -0400
X-MC-Unique: 7KKPy_nbNKe80ni1_V5aHQ-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a05600c1c8500b003974c5d636dso1059399wms.1
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 05:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S+74WIiIqDeXpjtoAD/TEU28DZze6OAJ67hCvQbNFLU=;
        b=cNf2JEakKOq0H99yOnMwB8+SfGl+YhT7WhkwdKijpMUtlg5TpN0yfjppPty+gS21V3
         lHuzYg/G60iAVWUimC7rcxeKvClwjS6nCeQCtG2qorFs8ndTvRUjc6JZq178/z2ha/Qz
         0/evZ+83OIb1rUBcRb6TgbD5SXQGcLohbLcTcXqkoYaRaFOyOKUdPO6dHoiFoi2LeQ72
         M1hGPyj1VAAD2NDWlTIWGwqgafEodRyFswy4iuZr2rFA7Q7Oa1dLpp1gev3Q8yaHFKaY
         W9kf3jIijxn5D4KAqWF49+g+k1twOd4RrOa4TzCUOWIzVrtvw4KjoLcAwC+Fa5aCR2kC
         CbEQ==
X-Gm-Message-State: AOAM532rEAQCxDyL3gKFLf5kgYEf3zSZ8vqqcq14zyW8NstyQqZqjJhX
        Fi60YeDTkJMyce11SS7iA6Af5y4dk+muqGpPS+cHfyeRvxtqgw2giw7ipx4otxQZOojqhGvQZwB
        VO3pLyZG1a4pHTlpsWGwe+/IN+MddWqvNIvk2FRqbM0dip9YGBU/VEWjtAYpMZu8=
X-Received: by 2002:a5d:6c62:0:b0:20f:cd17:a013 with SMTP id r2-20020a5d6c62000000b0020fcd17a013mr20271631wrz.503.1653569356455;
        Thu, 26 May 2022 05:49:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyTOt6NYSzvdhJQ6wvybsPu980wRiDWjS+YnfKM6Mh4Egd/EuMIggCc9lN6kIygnDlXb5gyA==
X-Received: by 2002:a5d:6c62:0:b0:20f:cd17:a013 with SMTP id r2-20020a5d6c62000000b0020fcd17a013mr20271611wrz.503.1653569356139;
        Thu, 26 May 2022 05:49:16 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id bd25-20020a05600c1f1900b0039466988f6csm5048461wmb.31.2022.05.26.05.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 05:49:15 -0700 (PDT)
Date:   Thu, 26 May 2022 14:49:14 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, nikos.nikoleris@arm.com
Subject: Re: [PATCH kvm-unit-tests v2 0/2] lib: Cleanups
Message-ID: <20220526124914.wbvs5ojdghigby2w@gator>
References: <20220520132404.700626-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520132404.700626-1-drjones@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 03:24:02PM +0200, Andrew Jones wrote:
> v2
> --
>   - remove a trailing whitespace [Nikos]
>   - add Nikos' r-b's
>   - add back a check for '_' in argv.c that got dropped
> 
> 1) Finally, finally, finally reformat printf.c and string.c, the last
>    two files that had weird formatting.
> 
> 2) Collect is* ctype functions into a new lib/ctype.h file.
> 
> Andrew Jones (2):
>   lib: Fix whitespace
>   lib: Add ctype.h and collect is* functions
> 
>  lib/argv.c   |   9 +-
>  lib/ctype.h  |  40 +++++
>  lib/printf.c | 427 +++++++++++++++++++++++++--------------------------
>  lib/string.c | 356 +++++++++++++++++++++---------------------
>  4 files changed, 432 insertions(+), 400 deletions(-)
>  create mode 100644 lib/ctype.h
> 
> -- 
> 2.34.3
>

Merged

https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/32

Thanks,
drew 

