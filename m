Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36EB4DAE79
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 11:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355214AbiCPKtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 06:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355215AbiCPKtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 06:49:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1AE5DF0C
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 03:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647427677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m59J7MgkhleMflQJKSz3faA86CMLj//PPhoxuvxryfM=;
        b=L7qDbrzpsLPMuqv+Sy5+eq4ddKOrnhkoehmS9WzvVmKAeNoKQO4XQxyj2AA9J/Rnsd4BXR
        /NNIC4ybCQ/FZdW5vMZPMgZzhrrsGUPRWAbX7zzV8WavUG3/BSlUdKf1kD8xdB/KQBOos/
        psGrA8i7o0GI9c5nlE2VUHIGcRaF6SQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-QiF3kFERMXSbqzlnLLgckQ-1; Wed, 16 Mar 2022 06:47:55 -0400
X-MC-Unique: QiF3kFERMXSbqzlnLLgckQ-1
Received: by mail-wm1-f70.google.com with SMTP id i6-20020a05600c354600b0038be262d9d9so1437364wmq.8
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 03:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m59J7MgkhleMflQJKSz3faA86CMLj//PPhoxuvxryfM=;
        b=gl00BK2TmB+CEmnpDxHeK82aewGeLTYjaj8aufW0MxyrsWD7hD65uObG/1x8IKLjRG
         KpHq7Xg/62AtQLodu51onurxFNJc18Vylbn1Or6ArMhkFlnKit5r+zIbYwQZAypGzfjB
         4HPGQfh6L5Vn9Dfq/wDTk4CvRGuvz0CxXU1Y8TkTLffLWjuTEdrRFuIFtBQ0TXtcezxu
         D06BYT+xXyFBWwr8Vnq5upRmoYiZdznJHLVVFwmieICNIk4BaK015nyaUbmwERZVEFPP
         2/3y/1V6iQrQeWgAU39Vmln7j2CQrC9zGh9X5RcQgQqQgZYuJ+6NQLo8+tvnf5D/b8+J
         IM0g==
X-Gm-Message-State: AOAM533vUUIc9W9dqPnW1En/zy1UAmsr1ecV930ZWQwyesm3Bx2KdsoW
        ZsoEeRIh0uj/uTUEfNFfQ8DyMtH0KjbFDnjCP3nz3PCCbvA5PMM7hdBdatlqvifc132wZJImRzr
        hVItms0QcqnXo
X-Received: by 2002:a7b:c7d8:0:b0:389:c3ca:9ede with SMTP id z24-20020a7bc7d8000000b00389c3ca9edemr6788347wmk.150.1647427674424;
        Wed, 16 Mar 2022 03:47:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyC6vn1CJxqhoPZm0/tWmoU5sy/ZcVyL6zqJSEZxDHf82DoHidC7KckFf1AcdwPz4NgLeFAXg==
X-Received: by 2002:a7b:c7d8:0:b0:389:c3ca:9ede with SMTP id z24-20020a7bc7d8000000b00389c3ca9edemr6788329wmk.150.1647427674119;
        Wed, 16 Mar 2022 03:47:54 -0700 (PDT)
Received: from redhat.com ([2.53.2.35])
        by smtp.gmail.com with ESMTPSA id p125-20020a1c2983000000b00389cc36a3bfsm4795053wmp.6.2022.03.16.03.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 03:47:53 -0700 (PDT)
Date:   Wed, 16 Mar 2022 06:47:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, qemu-devel@nongnu.org,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>
Subject: Re: [PATCH 1/4] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <20220316064631-mutt-send-email-mst@kernel.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
 <20220316100425.2758afc3@redhat.com>
 <d374107ebd48432b6c2b13c13c407a48fdb2d755.camel@infradead.org>
 <20220316055333-mutt-send-email-mst@kernel.org>
 <c359ac8572d0193dd65bb384f68873d24d0c72d3.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c359ac8572d0193dd65bb384f68873d24d0c72d3.camel@infradead.org>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 10:37:49AM +0000, David Woodhouse wrote:
> On Wed, 2022-03-16 at 05:56 -0400, Michael S. Tsirkin wrote:
> > On Wed, Mar 16, 2022 at 09:37:07AM +0000, David Woodhouse wrote:
> > > Yep, that's the guest operating system's choice. Not a qemu problem.
> > > 
> > > Even if you have the split IRQ chip, if you boot a guest without kvm-
> > > msi-ext-dest-id support, it'll refuse to use higher CPUs.
> > > 
> > > Or if you boot a guest without X2APIC support, it'll refuse to use
> > > higher CPUs. 
> > > 
> > > That doesn't mean a user should be *forbidden* from launching qemu in
> > > that configuration.
> > 
> > Well the issue with all these configs which kind of work but not
> > the way they were specified is that down the road someone
> > creates a VM with this config and then expects us to maintain it
> > indefinitely.
> > 
> > So yes, if we are not sure we can support something properly it is
> > better to validate and exit than create a VM guests don't know how
> > to treat.
> 
> Not entirely sure how to reconcile that with what Daniel said in
> https://lore.kernel.org/qemu-devel/Yi9BTkZIM3iZsvdK@redhat.com/ which
> was:
> 
> > We've generally said QEMU should not reject / block startup of valid
> > hardware configurations, based on existance of bugs in certain guest
> > OS, if the config would be valid for other guest.

For sure, but is this a valid hardware configuration? That's
really the question.

> That said, I cannot point at a *specific* example of a guest which can
> use the higher CPUs even when it can't direct external interrupts at
> them. I worked on making Linux capable of it, as I said, but didn't
> pursue that in the end.
> 
> I *suspect* Windows might be able to do it, based on the way the
> hyperv-iommu works (by cheating and returning -EINVAL when external
> interrupts are directed at higher CPUs).
> 
> 

-- 
MST

