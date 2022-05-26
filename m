Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA3E534AAC
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 09:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbiEZHOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 03:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbiEZHOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 03:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF15325E88
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 00:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653549256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oFiNE8GkAv+OfQPSUfTSRowfk0C3oYVYVFckBaStzik=;
        b=F6TWG+CZIEaOpWRlQDH3Rn5n9LkDpX755QAlJhhrLONGAiZ/hsMwQqd+C4tpQDuvakCLDL
        xtzfc6+2phIb+IJ/ZJp5oM5K4ygHyFQEr1ncdMh+sP1q1AKuWuXq4PslhNJQbABKUvPslM
        SLCBamMLC8uXXzwluPbc0heCYxn1hfM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-JDRnpJazMwS5j03zAvhylA-1; Thu, 26 May 2022 03:14:14 -0400
X-MC-Unique: JDRnpJazMwS5j03zAvhylA-1
Received: by mail-ed1-f71.google.com with SMTP id v1-20020a056402348100b0042b4442b954so482144edc.22
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 00:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oFiNE8GkAv+OfQPSUfTSRowfk0C3oYVYVFckBaStzik=;
        b=3NUozx4RRfInuhFLmXbEfOUapYr6w+gJTCZrccKeCYJ1U0YclHoxQSzRIn1ULqndxJ
         2G5wcb6ATYGd4+MOoBjfwrFZibuCKZF5XEvlA/+mo4KxRqvPARphHQN8dePRTVYWXHfX
         m1WFWLjk/38mhlRuaBjmp5IRrshBra/dUND2rwAGGBEs7kPK+hQrae0xh0C2kg2+e4sF
         rI2uBSDuRGiw8ro8I0f33ApOSmTL/32NpH+3oxDRvy9MKYcZJfZ580DXDe2FUSgsaxEG
         4HufoUPRn2l7PkZU/OllqBii4Yyytc5IUiwnf7WFuormoS6mfIQrf41d4qP8Ic4QmVjl
         BDRA==
X-Gm-Message-State: AOAM531NndgdKF7Iwgam+vB9sPGo9+yg57joGsLw1eBTY+inuQVBHhMq
        3CanVI5Tjzuu5MnpGJsguoWuOyr7i8sm730D11tFXV5MjJqpKY+urkV2kxADitHW1uZ73aMn+OA
        DfVdav+LX5VlF
X-Received: by 2002:a05:6402:5289:b0:42b:9c88:e1db with SMTP id en9-20020a056402528900b0042b9c88e1dbmr10384845edb.284.1653549253144;
        Thu, 26 May 2022 00:14:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiou+m9PsbQma6uzExzjydPFEHufHg7Da/yHuWQt21R5l30UCB/9JqtRLFro7z8RTX1RzaaA==
X-Received: by 2002:a05:6402:5289:b0:42b:9c88:e1db with SMTP id en9-20020a056402528900b0042b9c88e1dbmr10384836edb.284.1653549252995;
        Thu, 26 May 2022 00:14:12 -0700 (PDT)
Received: from gator (cst2-175-76.cust.vodafone.cz. [31.30.175.76])
        by smtp.gmail.com with ESMTPSA id q14-20020a50c34e000000b0042bb015df6asm429688edb.6.2022.05.26.00.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 00:14:12 -0700 (PDT)
Date:   Thu, 26 May 2022 09:14:10 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, nikos.nikoleris@arm.com
Subject: Re: [PATCH kvm-unit-tests v2 2/2] lib: Add ctype.h and collect is*
 functions
Message-ID: <20220526071410.y5n3y4umpciei62b@gator>
References: <20220520132404.700626-1-drjones@redhat.com>
 <20220520132404.700626-3-drjones@redhat.com>
 <9b7b7b08-d66c-7412-8217-c3bbbafd73a0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b7b7b08-d66c-7412-8217-c3bbbafd73a0@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 24, 2022 at 02:21:40PM +0200, Thomas Huth wrote:
> On 20/05/2022 15.24, Andrew Jones wrote:
> > We've been slowly adding ctype functions to different files without
> > even exporting them. Let's change that.
> > 
> > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> ...
> > diff --git a/lib/ctype.h b/lib/ctype.h
> > new file mode 100644
> > index 000000000000..0b43d626478a
> > --- /dev/null
> > +++ b/lib/ctype.h
> > @@ -0,0 +1,40 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> 
> Maybe we should use LGPL for the C library stuff? ... most other libc
> related files use LGPL, too.

Right. Will do.

> 
> Apart from that:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
drew

