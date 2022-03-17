Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33984DC24C
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 10:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiCQJHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 05:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiCQJHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 05:07:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B61671D12E4
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 02:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647507942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z+ukIf3kiOVMXn/ERkS8gsiSbJcPYbKIeczTnmt6zIs=;
        b=TqzLdynxf6Caf+v+29DqiapSgRAsTCopUhwbSAaWYYgUZ1MB7356maeQOt9XjDBZ53Yqvd
        0U1v9IfSAs3uq6N2LPBXoeX1c5Q2KKfoesOcymNJrvkkDt8evjsDqOAUAtU9To4jqybGQD
        +eh4C4hebw+JbwFPuiKLgBK2x/N+d8Q=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-QrDcf7wPNeyJZJC4aPULPw-1; Thu, 17 Mar 2022 05:05:39 -0400
X-MC-Unique: QrDcf7wPNeyJZJC4aPULPw-1
Received: by mail-ed1-f70.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so2758976edb.2
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 02:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z+ukIf3kiOVMXn/ERkS8gsiSbJcPYbKIeczTnmt6zIs=;
        b=kOrxTGftdAlzXo4obGBQHJy/IxgJYDJX8w4fvtYaLdm2HMGkL++Hdhdii0fzG1Facl
         jmjXmZmPaByvCuH1xjUzNmgLrouM4EI+DGqoAN3PXOAFOHtaJfRR6LvBHg07LGqNcxVU
         PcAfj7aaPrQsy1IXefNaLuwNnAba4h5/WP7P1sJ+7WM8ShPbolAnLPeUuzbSnA20ZW92
         6dZxKXLqwZ+CW4mq4N8RNduHa/X+u0aOhzSsdSzLfPl52xGzev/wThMZDn74A2bEx63f
         EUe9/zCAllR9a1lZhwF68D+eB3U72bd7cG2gCXZllKnkzMpjjdWl6UBoiIWPfLZqvvGr
         jMHQ==
X-Gm-Message-State: AOAM530i9UX4AO2mh1TKaFYK5CgU1SkTzY28wvQtCexEh3QYoOcXsT80
        bLVx7ou7RcbpbePPb06ulibvwCIIvMgtAC41MV67n1mWc0noTvN6RDQVkSic9fZtEbbxyMUPCt0
        owcUkvuPhIqtO
X-Received: by 2002:a17:906:3583:b0:6d1:c07:fac0 with SMTP id o3-20020a170906358300b006d10c07fac0mr3267536ejb.749.1647507938682;
        Thu, 17 Mar 2022 02:05:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAEpAf2oe79CJKooaY+Hdrq2dwgzYT5+C9uD9b7cVPMaIs2fpCbjk5CQdy6+XNKQp1HWBFOg==
X-Received: by 2002:a17:906:3583:b0:6d1:c07:fac0 with SMTP id o3-20020a170906358300b006d10c07fac0mr3267509ejb.749.1647507938397;
        Thu, 17 Mar 2022 02:05:38 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u24-20020a1709064ad800b006d70e40bd9esm2095558ejt.15.2022.03.17.02.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 02:05:37 -0700 (PDT)
Date:   Thu, 17 Mar 2022 10:05:36 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, berrange@redhat.com,
        qemu-devel@nongnu.org, Peter Xu <peterx@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>, vkuznets@redhat.com
Subject: Re: [PATCH 1/4] target/i386: Fix sanity check on max APIC ID /
 X2APIC enablement
Message-ID: <20220317100536.6ccabfe0@redhat.com>
In-Reply-To: <20220317094209.2888b431@redhat.com>
References: <20220314142544.150555-1-dwmw2@infradead.org>
        <20220316100425.2758afc3@redhat.com>
        <d374107ebd48432b6c2b13c13c407a48fdb2d755.camel@infradead.org>
        <20220316055333-mutt-send-email-mst@kernel.org>
        <c359ac8572d0193dd65bb384f68873d24d0c72d3.camel@infradead.org>
        <20220316064631-mutt-send-email-mst@kernel.org>
        <20220316122842.0bc78825@redhat.com>
        <2d2eb49f7a59918521c1614debe5b87017f5789b.camel@infradead.org>
        <20220317094209.2888b431@redhat.com>
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

re-sending reply as something went wrong with headers (I suspect Daniel's name formatting)
and email got bounced back.

On Wed, 16 Mar 2022 14:31:33 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2022-03-16 at 12:28 +0100, Igor Mammedov wrote:  
> > Generally Daniel is right, as long as it's something that what real hardware
> > supports. (usually it's job if upper layers which know what guest OS is used,
> > and can tweak config based on that knowledge).
> > 
> > But it's virt only extension and none (tested with
> >  Windows (hangs on boot),
> >  Linux (brings up only first 255 cpus)
> > ) of mainline OSes ended up up working as expected (i.e. user asked for this
> > many CPUs but can't really use them as expected).    
> 
> As I said, that kind of failure mode will happen even with the split
> irq chip and EXT_DEST_ID, with Windows and older (pre-5.10) Linux
> kernels.
> 
> For older guests it would also happen on real hardware, and in VMs
> where you expose an IOMMU with interrupt remapping. Some guests don't
> support interrupt remapping, or don't support X2APIC at all.
>   
> > Which would just lead to users reporting (obscure) bugs.    
> 
> It's not virt only. This could happen with real hardware.  

I was talking about EXT_DEST_ID kvm extension.
With current upstream guest kernel, user gets only "bad cpu" messages
and then go figure what's wrong with configuration or
simply hangs in case of Windows.

> > Testing shows, Windows (2019 and 2004 build) doesn't work (at least with
> > just kernel-irqchip=on in current state). (CCing Vitaly, he might know
> > if Windows might work and under what conditions)
> > 
> > Linux(recentish) was able to bring up all CPUs with APICID above 255
> > with 'split' irqchip and without iommu present (at least it boots to
> > command prompt).    
> 
> That'll be using the EXT_DEST_ID support.
>   
> > What worked for both OSes (full boot), was split irqchip + iommu
> > (even without irq remapping, but I haven't tested with older guests
> > so irq remapping might be required anyways).    
> 
> Hm, that's surprising for Windows unless it's learned to use the
> EXT_DEST_ID support. Or maybe it *can* cope with only targeting
> external interrupts at CPUs < 255 but has a gratuitous check that
> prevents it bringing them up unless there's an IOMMU... *even* if that
> IOMMU doesn't have irq remapping anyway?  

or maybe we are enabling irq remapping by default now.
I'll try to check, if guest is actually brings all CPUs up.

> Anyway, as fas as I'm concerned it doesn't matter very much whether we
> insist on the split irq chip or not. Feel free to repost your patch
> rebased on top of my fixes, which are also in my tree at
> https://git.infradead.org/users/dwmw2/qemu.git
> 
> The check you're modifying has moved to x86_cpus_init().  

if we are to keep iommu dependency then moving to x86_cpus_init()
isn't an option, it should be done at pc_machine_done() time.

in practice partial revert of your c1bb5418e to restore
iommu check including irq remapping.
In which case, do we still need kvm_enable_x2apic() check
you are adding here?

