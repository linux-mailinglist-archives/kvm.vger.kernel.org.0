Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFAA5B2E4D
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 07:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiIIFvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 01:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiIIFvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 01:51:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70D1B6D1A
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 22:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662702703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2D56kiwjTxsMbiId2ZRz9l3dEyBhF8jD87W2cREWCAY=;
        b=H3EeG6VqyrwueQbKl3Yi2RBwhWxj+UXoP8BdCILYnvhDcAjy/SJ2c2B1Z+4YyaJhao3MPJ
        PbPX/qetunS05AC1d0iHIfTCW9xb6jGGJdhiyVeQPpe2RzQG7CpbyqMfssemMG0sp3rZ0g
        3mmBn0lY61iFdZk/SDj+bvk6DAMO2O0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-647-rap5iTbHPhi5NmHOej7MwA-1; Fri, 09 Sep 2022 01:51:42 -0400
X-MC-Unique: rap5iTbHPhi5NmHOej7MwA-1
Received: by mail-wm1-f69.google.com with SMTP id c188-20020a1c35c5000000b003b2dee5fb58so326265wma.5
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 22:51:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2D56kiwjTxsMbiId2ZRz9l3dEyBhF8jD87W2cREWCAY=;
        b=A5tlJ17yB1pwUEIPGkzf0/IQB6JS4NYnaBLnd0xZUAtmXC5PkuSCa6f2V1YbP4C2mm
         lQlxmWd/Ovgyu7zA005RjtXl7cUX9rpH0ldAjY9+p+BjTIqRdk5BLWk62LBuaJU2K59W
         +EyF0pnh5is7f1ymgVgaqiEFtz00C1ZrXKJ0NezU20AKnXYxO9J3+ipUxqlwMWqF1afr
         rOwZwkfsqljk7OFh+XDqy4GgWQ3bPr4i3Zneu4QFdGYZeQ2TGSrZr3uSAbE67oIlf7TS
         +3p7OhEp5YkSmLSej1E4u51dFxzySDrmvkf0+B78hRJaLj+BkfcWRBA6j6QwoqzFG3Y4
         bOFA==
X-Gm-Message-State: ACgBeo2CE5R88AjGVkPDQHMlU84jxTC5x0nFws8ICF03MSZVo1M4J3tm
        0danf2ISqKDqdlhbD47+tdVQfCHk+ElCyzIQzC2y9zTUoBZIEh2WuXCuLwjAdGITulKhbCXDruf
        H57BPp0riItrc
X-Received: by 2002:adf:ef06:0:b0:228:d60c:cf74 with SMTP id e6-20020adfef06000000b00228d60ccf74mr6938824wro.302.1662702701528;
        Thu, 08 Sep 2022 22:51:41 -0700 (PDT)
X-Google-Smtp-Source: AA6agR74gOiwBGd3y82UHmOjC5S0D1ADceFESNa05Lk739UbQWKtxDuHMEJkfmmGM8FUwfmiuRdgOA==
X-Received: by 2002:adf:ef06:0:b0:228:d60c:cf74 with SMTP id e6-20020adfef06000000b00228d60ccf74mr6938809wro.302.1662702701281;
        Thu, 08 Sep 2022 22:51:41 -0700 (PDT)
Received: from redhat.com ([176.12.154.16])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003a607e395ebsm6221721wmq.9.2022.09.08.22.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 22:51:40 -0700 (PDT)
Date:   Fri, 9 Sep 2022 01:51:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: Re: [PATCH v2 2/2] [RfC] expose host-phys-bits to guest
Message-ID: <20220909014106-mutt-send-email-mst@kernel.org>
References: <20220908113109.470792-1-kraxel@redhat.com>
 <20220908113109.470792-3-kraxel@redhat.com>
 <20220908101757-mutt-send-email-mst@kernel.org>
 <20220909051817.vlai3l6cjl5sfgmv@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909051817.vlai3l6cjl5sfgmv@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 07:18:17AM +0200, Gerd Hoffmann wrote:
>   Hi,
> 
> > > @@ -424,7 +426,10 @@ static void microvm_device_pre_plug_cb(HotplugHandler *hotplug_dev,
> > >  {
> > >      X86CPU *cpu = X86_CPU(dev);
> > >  
> > > -    cpu->host_phys_bits = true; /* need reliable phys-bits */
> > > +    /* need reliable phys-bits */
> > > +    cpu->env.features[FEAT_KVM_HINTS] |=
> > > +        (1 << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID);
> > > +
> > 
> > Do we need compat machinery for this?
> 
> Don't think so, microvm has no versioned machine types anyway.
> 
> > > --- a/target/i386/cpu.c
> > > +++ b/target/i386/cpu.c
> 
> > >      [FEAT_KVM_HINTS] = {
> > >          .type = CPUID_FEATURE_WORD,
> > >          .feat_names = {
> > > -            "kvm-hint-dedicated", NULL, NULL, NULL,
> > > +            "kvm-hint-dedicated", "host-phys-bits", NULL, NULL,
> 
> > > -    DEFINE_PROP_BOOL("host-phys-bits", X86CPU, host_phys_bits, false),
> 
> > > -    if (cpu->host_phys_bits) {
> > > +    if (cpu->env.features[FEAT_KVM_HINTS] &
> > > +        (1 << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID)) {
> > >          /* The user asked for us to use the host physical bits */
> > >          phys_bits = host_phys_bits;
> > >          if (cpu->host_phys_bits_limit &&
> > 
> > I think we still want to key this one off host_phys_bits
> > so it works for e.g. hyperv emulation too.
> 
> I think that should be the case.  The chunks above change the
> host-phys-bits option from setting cpu->host_phys_bits to setting
> the FEAT_KVM_HINTS bit.  That should also happen with hyperv emulation
> enabled, and the bit should also be visible to the guest then, just at
> another location (base 0x40000100 instead of 0x40000000).
> 
> take care,
>   Gerd


You are right, I forgot. Hmm, ok. What about !cpu->expose_kvm ?

We have

    if (!kvm_enabled() || !cpu->expose_kvm) {
        env->features[FEAT_KVM] = 0;
    }   
        
This is quick grep, I didn't check whether this is called
after the point where you currently use it, but
it frankly seems fragile to pass a generic user specified flag
inside a cpuid where everyone pokes at it.


-- 
MST

