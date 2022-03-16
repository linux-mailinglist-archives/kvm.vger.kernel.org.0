Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204BE4DAEE6
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 12:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355338AbiCPLaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 07:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355310AbiCPLaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 07:30:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF2E22DEE
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 04:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647430127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDJPyenBafeObyzc12o3nx+8tkabTMk+C7BGe5YnLgU=;
        b=X46BRcRt2YlayDm3f/zWRGi+UGIi8+szs36zB+lOrETZiXLfZLmmENSsYDC80XOD3DrFQV
        hN46etozfa0sg0VnCgynIxX2y0lC/sGMVMlQJXP8IWPbXEZBn0tcphUhZCFQtln0ONktKK
        mdZAbVoHUnWdDxllsb8KmX8svcCmWhs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-t_vPQuhoMuuqyuzsjkNzeg-1; Wed, 16 Mar 2022 07:28:45 -0400
X-MC-Unique: t_vPQuhoMuuqyuzsjkNzeg-1
Received: by mail-ed1-f72.google.com with SMTP id w15-20020a50c44f000000b00418f00014f8so10888edf.18
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 04:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XDJPyenBafeObyzc12o3nx+8tkabTMk+C7BGe5YnLgU=;
        b=JCEGfHklkt1v5D0hYztbaA+AFFdiUXL9eIebniDDfQPxgFVKbZhDuS832IZ26ZXgJl
         GJNZwYrS2+v1Sp1wQ81cRqW4ZcM/daqbwnpHFr0cr6nYXdHNiseFOj0qmbwGYpkotEXh
         HYYhRlezBrnVtIYHOOwOLGU6jQ2gtG3N0noy1Ho0zsqweGzGbpQ7G8qaRYQvs/guI0Qm
         dM3boQriUNs5z6HBWHJsxGQPivfqN019wNV4bCZfbFqitPiOpkTkW5ZbIK1q0uyw8NER
         4RfPjE+FATEJlEW54JD29vR7L3RCQ3s8Hc2sHFFZuPrkB+LzM2QdA89TW7CrpWw9BsbO
         l6Hw==
X-Gm-Message-State: AOAM532KRNW1TSdWVeNDfW64BzZaiDz0G5jHNso3YTiiAY6w2xQdmkZu
        9KMlecMD3PczroUAsQwt8Qq6D2nR5Kmw5FGOaaUuY0ViQq6SuuBCCrKNBc1AeaM/V+wQWuNM8Kj
        /s4PvhVx7NR9w
X-Received: by 2002:a17:906:c04d:b0:6b9:252:c51c with SMTP id bm13-20020a170906c04d00b006b90252c51cmr26821725ejb.470.1647430124677;
        Wed, 16 Mar 2022 04:28:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyx2mlZdBuol72NuxKc6htHh6ZFXNkWFYMuCvgxhadk9MGd/vmwKG4u7L1mAI26xYIW3ltDDg==
X-Received: by 2002:a17:906:c04d:b0:6b9:252:c51c with SMTP id bm13-20020a170906c04d00b006b90252c51cmr26821705ejb.470.1647430124459;
        Wed, 16 Mar 2022 04:28:44 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id p23-20020a17090664d700b006db59e6a243sm792934ejn.53.2022.03.16.04.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 04:28:43 -0700 (PDT)
Date:   Wed, 16 Mar 2022 12:28:42 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        "Daniel P. =?UTF-8?B?QmVycmFu?= =?UTF-8?B?Z8Op?=" 
        <berrange@redhat.com>, qemu-devel@nongnu.org,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>, vkuznets@redhat.com
Subject: Re: [PATCH 1/4] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <20220316122842.0bc78825@redhat.com>
In-Reply-To: <20220316064631-mutt-send-email-mst@kernel.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
        <20220316100425.2758afc3@redhat.com>
        <d374107ebd48432b6c2b13c13c407a48fdb2d755.camel@infradead.org>
        <20220316055333-mutt-send-email-mst@kernel.org>
        <c359ac8572d0193dd65bb384f68873d24d0c72d3.camel@infradead.org>
        <20220316064631-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Mar 2022 06:47:48 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Mar 16, 2022 at 10:37:49AM +0000, David Woodhouse wrote:
> > On Wed, 2022-03-16 at 05:56 -0400, Michael S. Tsirkin wrote:  
> > > On Wed, Mar 16, 2022 at 09:37:07AM +0000, David Woodhouse wrote:  
> > > > Yep, that's the guest operating system's choice. Not a qemu problem.
> > > > 
> > > > Even if you have the split IRQ chip, if you boot a guest without kvm-
> > > > msi-ext-dest-id support, it'll refuse to use higher CPUs.
> > > > 
> > > > Or if you boot a guest without X2APIC support, it'll refuse to use
> > > > higher CPUs. 
> > > > 
> > > > That doesn't mean a user should be *forbidden* from launching qemu in
> > > > that configuration.  
> > > 
> > > Well the issue with all these configs which kind of work but not
> > > the way they were specified is that down the road someone
> > > creates a VM with this config and then expects us to maintain it
> > > indefinitely.
> > > 
> > > So yes, if we are not sure we can support something properly it is
> > > better to validate and exit than create a VM guests don't know how
> > > to treat.  
> > 
> > Not entirely sure how to reconcile that with what Daniel said in
> > https://lore.kernel.org/qemu-devel/Yi9BTkZIM3iZsvdK@redhat.com/ which
> > was:

Generally Daniel is right, as long as it's something that what real hardware
supports. (usually it's job if upper layers which know what guest OS is used,
and can tweak config based on that knowledge).

But it's virt only extension and none (tested with
 Windows (hangs on boot),
 Linux (brings up only first 255 cpus)
) of mainline OSes ended up up working as expected (i.e. user asked for this
many CPUs but can't really use them as expected).
Which would just lead to users reporting (obscure) bugs.

> > > We've generally said QEMU should not reject / block startup of valid
> > > hardware configurations, based on existance of bugs in certain guest
> > > OS, if the config would be valid for other guest.  
> 
> For sure, but is this a valid hardware configuration? That's
> really the question.

to me it looks like not complete PV feature so far.
if it's a configuration that is interesting for some users (some special
build OS/appliance that can use CPUs which are able to handle only IPIs)
or for development purposes than in should be an opt-in feature
instead of default one.
 
> > That said, I cannot point at a *specific* example of a guest which can
> > use the higher CPUs even when it can't direct external interrupts at
> > them. I worked on making Linux capable of it, as I said, but didn't
> > pursue that in the end.
> > 
> > I *suspect* Windows might be able to do it, based on the way the
> > hyperv-iommu works (by cheating and returning -EINVAL when external
> > interrupts are directed at higher CPUs).
Testing shows, Windows (2019 and 2004 build) doesn't work (at least with
just kernel-irqchip=on in current state). (CCing Vitaly, he might know
if Windows might work and under what conditions)

Linux(recentish) was able to bring up all CPUs with APICID above 255
with 'split' irqchip and without iommu present (at least it boots to
command prompt).

What worked for both OSes (full boot), was split irqchip + iommu
(even without irq remapping, but I haven't tested with older guests
so irq remapping might be required anyways).

