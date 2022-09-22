Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2705E5EFF
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 11:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiIVJxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 05:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiIVJxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 05:53:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA9CD5765
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 02:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663840401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uqJ3fE+nUSVE7dKPp8g2E2Nsm1KKt4x6Y9AxJhIcEaY=;
        b=a0S9VAXW5qKx3AkXbIwcx4HKVRfLAp+EhMkXe4jvuQ1TKUJKEBogDIYTFfu07ZLRprv7XN
        J3PbiCqC1nPiEUr1j8f9Q5sl13MmmcNHPlG+sf2J7Jfkm2Pnb6BuY6TM6T9IoFl5fYmJVE
        HbYsNu8bo2CHKGnNRcnpCZVFqjqu/+k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-445-8aw6ou6vPbSW2ZClXx5Atg-1; Thu, 22 Sep 2022 05:53:20 -0400
X-MC-Unique: 8aw6ou6vPbSW2ZClXx5Atg-1
Received: by mail-wm1-f70.google.com with SMTP id v190-20020a1cacc7000000b003b4ab30188fso846197wme.2
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 02:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=uqJ3fE+nUSVE7dKPp8g2E2Nsm1KKt4x6Y9AxJhIcEaY=;
        b=t8mFqEQ7Y9GA2mMJKaJ6GbZJ4m93iV27Pd2BDOIxojZIMS0d5B4J0XhnCQVocUlgUH
         kRak/A2v5cZwh/hCQ5a4Sf5q2qiXN+3yZePH5Bc92v5pOsFbPYg+93SUMqVmqMutcncH
         myqWxP/uHH2WUcwZR5TDjbUiP7cs9mc/fif9pXp9XMd4VW89YCzqMfNLjyc54RqH/W78
         uoS4clzn9OYUFMKgs2fvSRrg0kNu87qIWnovPuCqWnwn8Vg/LUZagoI2S7sZD6FcEO6A
         ubQ0jkMwAN+rHWEt2ppVpQaUvBHdjtVdXDoPq+cOjzMh+5jtgjOWdkTMVrU/Lqwm2SNY
         8LWg==
X-Gm-Message-State: ACrzQf16f9sRfUFoh6Q6WFQky2WGSUmW17bsTMp3+lTouGHSKN2lpAnW
        E019Wfn2Th2lKNWFOEAFCayJHJy2u0Ily3rjWG4Mgj38pTUe4PFJKFIi9bQTsKPuGf8oKFB7J3K
        fgbMwVV6GR5v0
X-Received: by 2002:a5d:5503:0:b0:22a:2fd7:d778 with SMTP id b3-20020a5d5503000000b0022a2fd7d778mr1417323wrv.44.1663840399284;
        Thu, 22 Sep 2022 02:53:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4I0G9hKFZfByPGx9z5GwmZTjbtZsg9cph4nZ5xMcSQZeWuytkQr4J3evHBJ1Eu2JfCei19RA==
X-Received: by 2002:a5d:5503:0:b0:22a:2fd7:d778 with SMTP id b3-20020a5d5503000000b0022a2fd7d778mr1417303wrv.44.1663840399015;
        Thu, 22 Sep 2022 02:53:19 -0700 (PDT)
Received: from redhat.com ([2.55.47.213])
        by smtp.gmail.com with ESMTPSA id v10-20020a5d590a000000b002206203ed3dsm4604135wrd.29.2022.09.22.02.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 02:53:18 -0700 (PDT)
Date:   Thu, 22 Sep 2022 05:53:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] x86: add etc/phys-bits fw_cfg file
Message-ID: <20220922054648-mutt-send-email-mst@kernel.org>
References: <20220922084356.878907-1-kraxel@redhat.com>
 <20220922044906-mutt-send-email-mst@kernel.org>
 <20220922093710.q3pxbxljdhu4a4yw@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922093710.q3pxbxljdhu4a4yw@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 11:37:10AM +0200, Gerd Hoffmann wrote:
> On Thu, Sep 22, 2022 at 04:55:16AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 22, 2022 at 10:43:56AM +0200, Gerd Hoffmann wrote:
> > > In case phys bits are functional and can be used by the guest (aka
> > > host-phys-bits=on) add a fw_cfg file carrying the value.  This can
> > > be used by the guest firmware for address space configuration.
> > > 
> > > This is only enabled for 7.2+ machine types for live migration
> > > compatibility reasons.
> > > 
> > > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > 
> > I'm curious why you decided to switch from a cpuid flag to fw cfg.
> 
> The kernel people didn't like the cpuid approach.
> 
> > I guess firmware reads fw cfg anyway.
> 
> Correct.
> 
> > But would the guest kernel then need to load a fw cfg driver very
> > early to detect this, too?
> 
> Nope, the guest kernel can just work with the address space layout
> created by the firmware.  The firmware can for example reserve a
> larger 64-bit mmio window in case there is enough address space for
> that.  So it programs the bridge windows etc accordingly, qemu
> generates matching acpi tables and the kernel picks up the changes
> via _CRS.
> 
> > > +void fw_cfg_phys_bits(FWCfgState *fw_cfg)
> > > +{
> > > +    X86CPU *cpu = X86_CPU(first_cpu);
> > > +    uint64_t phys_bits = cpu->phys_bits;
> > > +
> > > +    if (cpu->host_phys_bits) {
> > > +        fw_cfg_add_file(fw_cfg, "etc/phys-bits",
> > > +                        g_memdup2(&phys_bits, sizeof(phys_bits)),
> > > +                        sizeof(phys_bits));
> > > +    }
> > > +}
> > 
> > So, this allows a lot of flexibility, any phys_bits value at all can now
> > be used. Do you expect a use-case for such a flexible mechanism?  If
> > this ends up merely repeating CPUID at all times then we are just
> > creating confusion.
> 
> Yes, it'll just repeat CPUID.  Advantage is that the guest gets the
> information it needs right away.
> 
> Alternatively I could create a "etc/reliable-phys-bits" bool.
> The firmware must consult both fw_cfg and cpuid then.
> 
> take care,
>   Gerd

It might not be too bad if we actually allow these two to be different
theoretically (even if unused for now).
This is up to you. But my point is, if we do let's document what is the
expected behaviour if fw cfg and CPUID differ.



-- 
MST

