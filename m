Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746665A2927
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 16:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344214AbiHZON4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 10:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbiHZONx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 10:13:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EAB979ED
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661523231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GQ+6AbMK/VzzgwCX5/3G69+rKn+A93ZLmXM6dTBFuQY=;
        b=JXiWycndh6j04Eh8H91BsD0LO87CocEOowVbW9yfKBrklJb4uVRlZpinnyP9KMXDGAw8QE
        RXvCZI0Bt6TaRYuHIA9VpW42DYatv0/uUytNQqmjU3miN/zxaEykdoXNkZ+bP9NSFRl7qU
        a/5auX6tJqjAIT4ZlsZG9lyY8t2kszg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-402-QUSXd5OQOOGq2jqNpdf-gQ-1; Fri, 26 Aug 2022 10:13:50 -0400
X-MC-Unique: QUSXd5OQOOGq2jqNpdf-gQ-1
Received: by mail-qk1-f198.google.com with SMTP id h20-20020a05620a245400b006bb0c6074baso1328648qkn.6
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:13:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=GQ+6AbMK/VzzgwCX5/3G69+rKn+A93ZLmXM6dTBFuQY=;
        b=haYOFzQeJawCvr+O20qIU3NrZ8BIYQ4DTjGd1GkdKpXvcdRyUyCAOVkC808oqB0pAL
         GySz/O5RVVaRzXUnRiqJ4VS05RaQSapzJjhdsv+muP8flJevNRM2iYzEIm/hOE/YPP/f
         aTA+kn8TUOop7SFPKvYK33qoGKkSbuLcEhSdpfOGJfk4Byj6XAshLL/IgPeZf26gT8Hq
         O95eKtNt+J2LGgJRRszHyjBqJZQE+vFWFZ9rN2hxqyQCwTs19IGUgH2FpT9++4N8Icgy
         TFijNH4llQGV6dpWQ43q+JToIX7iMGASFYm2eB5PP85CXtXDl+arP/MLY6vgG6pmmOFK
         xQtg==
X-Gm-Message-State: ACgBeo0TZynpRvaNbw93hk9XWTUhNzUY9J2cpLqfO8omN7JvyxbLy8ml
        xUxFmZ2uwodd870Kxwek3nsFyWZNQABWmbfUvIDZpA0xk3SkeTnLNoBSKClPl2qUs5Yr7tvz3aR
        ZmLe0IW4t4Wdf
X-Received: by 2002:a05:622a:1343:b0:343:5b7:ffb with SMTP id w3-20020a05622a134300b0034305b70ffbmr8165262qtk.91.1661523229877;
        Fri, 26 Aug 2022 07:13:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4jReA0QpSlG/6gNrVfZ7v6crpcmNYSzbMoyGBauyk17ML/pe15D/kCE+6aUCVDOP6AseSh8Q==
X-Received: by 2002:a05:622a:1343:b0:343:5b7:ffb with SMTP id w3-20020a05622a134300b0034305b70ffbmr8165236qtk.91.1661523229665;
        Fri, 26 Aug 2022 07:13:49 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id c3-20020a05620a268300b006bb0f9b89cfsm1905603qkp.87.2022.08.26.07.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 07:13:49 -0700 (PDT)
Date:   Fri, 26 Aug 2022 10:13:47 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] softmmu/memory: add missing begin/commit
 callback calls
Message-ID: <YwjVG+MR8ORLngjd@xz-m1.local>
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-2-eesposit@redhat.com>
 <Yv6UVMMX/hHFkGoM@xz-m1.local>
 <e5935ba7-dd60-b914-3b1d-fff4f8c01da3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e5935ba7-dd60-b914-3b1d-fff4f8c01da3@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022 at 03:53:09PM +0200, Emanuele Giuseppe Esposito wrote:
> What do you mean "will empty all regions with those listeners"?
> But yes theoretically vhost-vdpa and physmem have commit callbacks that
> are independent from whether region_add or other callbacks have been called.
> For kvm and probably vhost it would be no problem, since there won't be
> any list to iterate on.

Right, begin()/commit() is for address space update, so it should be fine
to have nothing to commit, sorry.

> 
> I'll implement a new macro to handle this.

Sounds good.  Thanks,

-- 
Peter Xu

