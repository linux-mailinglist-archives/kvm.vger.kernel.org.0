Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071894DADF7
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 10:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355082AbiCPJ5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 05:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355077AbiCPJ5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 05:57:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5336365783
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 02:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647424578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8gfOJPBMdn5aVKRsDQiIEUMI7ZZ3LrW25gO3tb6x07Q=;
        b=TQls3rdC03HkrdBJtP94YubPyx2nbGjYe6n+FkTwlrpktuPPRGz8ymx2VTFlxivWcZFg0h
        aKO0cSiHdBcO1UJyR1/TGAajJWwYjXQC4qMVOB0iBuZG5uczAT0KUdKxleVfXqY9CCKv4J
        VsIYZ0Si9HUtXtV/BdcNjOGGASc0Rjw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-K6ZsvBDgNIyfy1O52o4--A-1; Wed, 16 Mar 2022 05:56:17 -0400
X-MC-Unique: K6ZsvBDgNIyfy1O52o4--A-1
Received: by mail-wm1-f70.google.com with SMTP id m34-20020a05600c3b2200b0038115c73361so571062wms.5
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 02:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8gfOJPBMdn5aVKRsDQiIEUMI7ZZ3LrW25gO3tb6x07Q=;
        b=KsH+VVqkvekj3EAyeegDVeUTYdWK4eg96rW/NxdIlrJuK7TL2PVss44xDY0EiLK9iB
         PuiBgAGAbn6L/lOXAu0ecq80GvillHJ2rW8Fy9tmCB853HK2Lanr+ggr8b8yzOupJRMC
         j02oXAE+uayKJUBw7bkc3gtkW1FlZ5TItgUCdiWhoj9gKOTk0wfL55CUWtFJ6TiBJZJw
         Lu7rZhDuXJIJbACpfs7iT84/G+6oQ9LOAzHeyOgdSVIvICikKG5ZcBGuXMLQ8f4HotIw
         w1EbYsliX1xejhcSdYuwmpK98sh8TvcqsFcfouAd9CXfDTqsRtAlE3QyZboLsX21AZKb
         uoRw==
X-Gm-Message-State: AOAM533RRJR+YNAtjP/e0CQFqr7b4h+D+zW/2QGrKPvL3zwMGp8S+xIl
        pVsup1AhRftBmbdKN9SJD+qtBp4OWqsq8SAklysA8eVBreOH+JGm1nLZJrYP2fQFanB2CeTsS3Z
        nFl7xD5G5Gh95
X-Received: by 2002:adf:df01:0:b0:203:d6f0:794b with SMTP id y1-20020adfdf01000000b00203d6f0794bmr5042677wrl.394.1647424575722;
        Wed, 16 Mar 2022 02:56:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuJ/NQx+ZV6UwXmJ9H2H0g0ol9oQfOGUZP0Yk+IZ3tjm0OXRPniE8Hh8CnhZOLbPCMbkeJpA==
X-Received: by 2002:adf:df01:0:b0:203:d6f0:794b with SMTP id y1-20020adfdf01000000b00203d6f0794bmr5042662wrl.394.1647424575492;
        Wed, 16 Mar 2022 02:56:15 -0700 (PDT)
Received: from redhat.com ([2.53.2.35])
        by smtp.gmail.com with ESMTPSA id o12-20020adfa10c000000b001efb97fae48sm1260431wro.80.2022.03.16.02.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:56:14 -0700 (PDT)
Date:   Wed, 16 Mar 2022 05:56:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Igor Mammedov <imammedo@redhat.com>, qemu-devel@nongnu.org,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>,
        Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>
Subject: Re: [PATCH 1/4] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <20220316055333-mutt-send-email-mst@kernel.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
 <20220316100425.2758afc3@redhat.com>
 <d374107ebd48432b6c2b13c13c407a48fdb2d755.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d374107ebd48432b6c2b13c13c407a48fdb2d755.camel@infradead.org>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 09:37:07AM +0000, David Woodhouse wrote:
> On Wed, 2022-03-16 at 10:04 +0100, Igor Mammedov wrote:
> > Well, I retested with the latest upstream kernel (both guest and host),
> > and adding kvm_enable_x2apic() is not sufficient as guest according
> > to your patches in kernel caps max APICID at 255 unless kvm-msi-ext-dest-id
> > is enabled. And attempt in enabling kvm-msi-ext-dest-id with kernel-irqchip
> > fails.
> 
> Correctly so. We need the split irqchip to support kvm-msi-ext-dest-id
> which is why there's an explicity check for it.
> 
> > So number of usable CPUs in guest stays at legacy level, leaving the rest
> > of CPUs in limbo.
> 
> Yep, that's the guest operating system's choice. Not a qemu problem.
> 
> Even if you have the split IRQ chip, if you boot a guest without kvm-
> msi-ext-dest-id support, it'll refuse to use higher CPUs.
> 
> Or if you boot a guest without X2APIC support, it'll refuse to use
> higher CPUs. 
> 
> That doesn't mean a user should be *forbidden* from launching qemu in
> that configuration.

Well the issue with all these configs which kind of work but not
the way they were specified is that down the road someone
creates a VM with this config and then expects us to maintain it
indefinitely.

So yes, if we are not sure we can support something properly it is
better to validate and exit than create a VM guests don't know how
to treat.

-- 
MST

