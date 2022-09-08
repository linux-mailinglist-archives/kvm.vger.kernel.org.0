Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9288E5B11DA
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 03:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiIHBKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 21:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiIHBKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 21:10:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C21992F66
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 18:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662599428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KBVNTAaj/cyOP+0D1quiD6nGu9/sCuXJHNiZG6zvz1Y=;
        b=A1K15Ty4XihboY0f5XxbwOpdvHZBzMreAwCGOJ2zz8m7nW4PpaoR/St44omGc1+VogmjSJ
        dWLq1bf6+mlSS1KsCWXwMRQ3ncxzAxVSXJOwtFhBwgCnq9AV//HQor2GLIvhBi3k7UdjfS
        Eai4RpjwPPkB6vNNNXdfC9oApk0U6ss=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-354-Ssn6pAV4N9uEzj3kPRBMvg-1; Wed, 07 Sep 2022 21:10:21 -0400
X-MC-Unique: Ssn6pAV4N9uEzj3kPRBMvg-1
Received: by mail-il1-f200.google.com with SMTP id b9-20020a92c569000000b002eb7fbf5ca1so13654750ilj.20
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 18:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=KBVNTAaj/cyOP+0D1quiD6nGu9/sCuXJHNiZG6zvz1Y=;
        b=0TZX48Tk3IvLE45Rqnd5hP5njdROAcYkQGLDoLLjORAn4v14cPuITJRT/gyDP9ZJqF
         cWBsg6mmoGf/wSNTJECqWdjvK5/KeuT/V3stfj7WX8EAO9Wl/7SsesGz661tZcuEFe31
         68f3kK2hIgRhd0xAeC+WFE98o8XZ2q4/DNYR3NKDbNg0sp84pwVyJOxPVmRlqKeec445
         Yr/hRgV6ivb846BSBN4VQxxBwcT9vLLUUYJ2gH2iUCNOV2CFbmWJ0LZPHriTZuYuU7Ms
         RHO/PqUjC1OZBWm5l2bDjpgV79WtUBleFd7Jw4PwjnyNsGMryU9QLsq/602MdbDlK0y4
         LkDw==
X-Gm-Message-State: ACgBeo1iNwYXYdELP25YHTkls85LUQQ0V0hhy4hnxXBN6C5DqH127y7R
        5J6kKRVzSNvAnSfsoZb9CUSeXy8piNfMgB33pwV7QMbsPmcrHg8tRCgR+PfusQWX3MIRF74SNuH
        BPJt3xhpcWPa8
X-Received: by 2002:a05:6638:2614:b0:350:248:ab1a with SMTP id m20-20020a056638261400b003500248ab1amr3637713jat.269.1662599421194;
        Wed, 07 Sep 2022 18:10:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6MvU+kgY20NRGKN9anTKXZxglys0F1AnqNzqNoZt+NdhDd+9sucOubCjbbgHlRJMMzGYqI+w==
X-Received: by 2002:a05:6638:2614:b0:350:248:ab1a with SMTP id m20-20020a056638261400b003500248ab1amr3637696jat.269.1662599420949;
        Wed, 07 Sep 2022 18:10:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 66-20020a020a45000000b00349c2336d39sm7820954jaw.171.2022.09.07.18.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 18:10:20 -0700 (PDT)
Date:   Wed, 7 Sep 2022 19:10:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     David Hildenbrand <david@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
Message-ID: <20220907191019.6340f754.alex.williamson@redhat.com>
In-Reply-To: <YxkkFiToNSw3CgrP@ziepe.ca>
References: <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
        <YxfX+kpajVY4vWTL@ziepe.ca>
        <b365f30b-da58-39c0-08e9-c622cc506afa@redhat.com>
        <YxiTOyGqXHFkR/DY@ziepe.ca>
        <20220907095552.336c8f34.alex.williamson@redhat.com>
        <YxjJlM5A0OLhaA7K@ziepe.ca>
        <20220907125627.0579e592.alex.williamson@redhat.com>
        <Yxj3Ri8pfqM1SxWe@ziepe.ca>
        <20220907142416.4badb879.alex.williamson@redhat.com>
        <YxkkFiToNSw3CgrP@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Sep 2022 20:07:02 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, Sep 07, 2022 at 02:24:16PM -0600, Alex Williamson wrote:
> 
> > Also, I want to clarify, is this a recommendation relative to the
> > stable patch proposed here, or only once we get rid of shared zero page
> > pinning?  We can't simply do accounting on the shared zero page since a
> > single user can overflow the refcount.  
> 
> Yes, here I would account properly in a way that keeps working for
> future GUP changes because if something goes wrong with this simple
> patch it has a simple fix.
> 
> Trialing it will get some good data to inform what David's patch
> should do.
> 
> Overall have the feeling that a small group of people might grumble
> that their limits break, but with a limit adjustment they can probably
> trivially move on. It would be very interesting to see if someone
> feels like the issue is important enough to try and get something
> changed.
> 
> You could also fix it by just using FOLL_FORCE (like RDMA/io_uring
> does), which fixes the larger issue Kevin noted that the ROM doesn't
> become visible to DMA.

That's only a theoretical problem, I suspect there are absolutely zero
cases where this is an actual problem.  Doing anything other than
simply fixing the leak for stable seems reckless, we're not actually
consuming resources that need to be accounted until David's changes
come through, and we risk breaking users on a broad scale.  IMO, the
fix proposed here is the correct first step and we can start
experimenting with accounting the zero page moving forward.  Thanks,

Alex

