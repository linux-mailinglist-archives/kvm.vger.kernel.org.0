Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7B85AC65C
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 22:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiIDUiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 16:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiIDUiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 16:38:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1661125C6B
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 13:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662323886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qZEMRRzOCR1TTFHYlRiqnE2jgjqBJRmYnAjYlrl73fU=;
        b=Hc/tiuY1y+2dJ/anR92/N2C2TK+ikmGrqC//GX57eGl83sL4uDW7Q9WlpzJmqeMVsJiPNi
        fg7biOeiSsghgDsWH6xyIgQl1ZVyr35RxMcZ3qnHmjv2DQBbGDUA2hLoPA8nTW3OG05dIz
        zCJzin+tTJbnNWKRngiRcZuN4Jt6MiE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-6jDuqjsRNZCYVr8OsH5_mA-1; Sun, 04 Sep 2022 16:38:04 -0400
X-MC-Unique: 6jDuqjsRNZCYVr8OsH5_mA-1
Received: by mail-wm1-f71.google.com with SMTP id b16-20020a05600c4e1000b003a5a47762c3so4408215wmq.9
        for <kvm@vger.kernel.org>; Sun, 04 Sep 2022 13:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qZEMRRzOCR1TTFHYlRiqnE2jgjqBJRmYnAjYlrl73fU=;
        b=SFmQdKI+XJ+OeGGZNl22coxd9F33a6BiAXvUD0zniQlmbzRckVLfZToE4mWpijTc2Q
         SmHTpe/rP6OJE+0OAYiXnrZJJQ0aDXaIbKgOs6L6Ng13tPv361w4UA5YfDOasd02g1yr
         QyF/WkWB+3N4n4GxrJCoH3TmaySRxPkNSOE9o/ERaN9OV6cG7a+RLUJfukV/9xIKMSFN
         n3ivjb0BkAsZHdzpTreNJzuCTo427Q/W19F7KBQC2H5aavD2nzv0C7sIRZOIu1SXc7sf
         B8Syr1LG8T1gDwhs9LvJWKLv+kyvcn6R5thYF6/UxATeOImV/Yz5AGM+yAVPybF8sDGN
         Wsfg==
X-Gm-Message-State: ACgBeo3VDrpLqckYPgPKazfNME+2PP3+iCJSRdcffXFx/4pkaVakYmzK
        A36IQbikjmVKZPlZGe4wGU0qjGIkUs1bgetk+5XKJXD257BJ8gO4bE+WNjjFUt8K2q5owuZqGWp
        Lap0PcecyLqyx
X-Received: by 2002:a5d:4246:0:b0:228:a8b6:ccf5 with SMTP id s6-20020a5d4246000000b00228a8b6ccf5mr150047wrr.7.1662323883658;
        Sun, 04 Sep 2022 13:38:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4oMzU+f7JCGIDCD1lsWOkDlMvnqcipAxZafpBoyxzgHX2YwZPkIx9gSd29MxHsffedZdjtdA==
X-Received: by 2002:a5d:4246:0:b0:228:a8b6:ccf5 with SMTP id s6-20020a5d4246000000b00228a8b6ccf5mr150040wrr.7.1662323883385;
        Sun, 04 Sep 2022 13:38:03 -0700 (PDT)
Received: from redhat.com ([2.52.135.118])
        by smtp.gmail.com with ESMTPSA id m23-20020a05600c3b1700b003a5e7435190sm17060561wms.32.2022.09.04.13.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 13:38:02 -0700 (PDT)
Date:   Sun, 4 Sep 2022 16:37:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>
Subject: Re: [PATCH 0/2] expose host-phys-bits to guest
Message-ID: <20220904163609-mutt-send-email-mst@kernel.org>
References: <20220831125059.170032-1-kraxel@redhat.com>
 <957f0cc5-6887-3861-2b80-69a8c7cdd098@intel.com>
 <20220901135810.6dicz4grhz7ye2u7@sirius.home.kraxel.org>
 <f7a56158-9920-e753-4d21-e1bcc3573e27@intel.com>
 <20220901161741.dadmguwv25sk4h6i@sirius.home.kraxel.org>
 <34be4132-53f4-8779-1ada-68aa554e0eac@intel.com>
 <20220902060720.xruqoxc2iuszkror@sirius.home.kraxel.org>
 <20220902021628-mutt-send-email-mst@kernel.org>
 <20220902084420.noroojfcy5hnngya@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902084420.noroojfcy5hnngya@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 10:44:20AM +0200, Gerd Hoffmann wrote:
>   Hi,
>  
> > I feel there are three major sources of controversy here
> > 
> > 0. the cover letter and subject don't do such a good job
> >    explaining that what we are doing is just telling guest
> >    CPUID is not broken. we are not exposing anything new
> >    and not exposing host capability to guest, for example,
> >    if cpuid phys address is smaller than host things also
> >    work fine.
> > 
> > 1. really the naming.  We need to be more explicit that it's just a bugfix.
> 
> Yep, I'll go improve that for v2.
> 
> > 2. down the road we will want to switch the default when no PV. however,
> >    some hosts might still want conservative firmware for compatibility
> >    reasons, so I think we need a way to tell firmware
> >    "ignore phys address width in CPUID like you did in the past".
> >    let's add a flag for that?
> >    and if none are set firmware should print a warning, though I
> >    do not know how many people will see that. Maybe some ;)
> 
> > /*
> >  * Force firmware to be very conservative in its use of physical
> >  * addresses, ignoring phys address width in CPUID.
> >  * Helpful for migration between hosts with different capabilities.
> >  */
> > #define KVM_BUG_PHYS_ADDRESS_WIDTH_BROKEN 2
> 
> I don't see a need for that.  Live migration compatibility can be
> handled just fine today using
> 	'host-phys-bits=on,host-phys-bits-limit=<xx>'
> 
> Which is simliar to 'phys-bits=<xx>'.

yes but what if user did not configure anything?

the point of the above is so we can eventually, in X years, change the guests
to trust CPUID by default.

> The important difference is that phys-bits allows pretty much anything
> whereas host-phys-bits-limit applies sanity checks against the host
> supported phys bits and throws error on invalid values.
> 
> take care,
>   Gerd

