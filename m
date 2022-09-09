Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ADD5B2DFC
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 07:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiIIFSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 01:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiIIFS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 01:18:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3F15D0C6
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 22:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662700705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AIbzNz29YPbmCVTVBXbJyWztnZBv3IdFfpT/fzMMz78=;
        b=isohFQgmK4Ql5aFv7ely9Hv94jy4ing900CaGG1sylDSHoqoQsgtIr5chwxxHM0f2eFnf9
        CUZL7CqS6vJN3UfddsZDp2ToxdSwW+i5cbuXcxKNXQVgY5mwAFFvwPt4cUqTrn9XURx7xe
        8dJrERPfRI23LPOzvsiE9GSpphoW7i4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-SkMWKDKfMhehCQYp-wWwbg-1; Fri, 09 Sep 2022 01:18:19 -0400
X-MC-Unique: SkMWKDKfMhehCQYp-wWwbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5C643802121;
        Fri,  9 Sep 2022 05:18:18 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B0122026D4C;
        Fri,  9 Sep 2022 05:18:18 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 48F1518000A3; Fri,  9 Sep 2022 07:18:17 +0200 (CEST)
Date:   Fri, 9 Sep 2022 07:18:17 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: Re: [PATCH v2 2/2] [RfC] expose host-phys-bits to guest
Message-ID: <20220909051817.vlai3l6cjl5sfgmv@sirius.home.kraxel.org>
References: <20220908113109.470792-1-kraxel@redhat.com>
 <20220908113109.470792-3-kraxel@redhat.com>
 <20220908101757-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908101757-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > @@ -424,7 +426,10 @@ static void microvm_device_pre_plug_cb(HotplugHandler *hotplug_dev,
> >  {
> >      X86CPU *cpu = X86_CPU(dev);
> >  
> > -    cpu->host_phys_bits = true; /* need reliable phys-bits */
> > +    /* need reliable phys-bits */
> > +    cpu->env.features[FEAT_KVM_HINTS] |=
> > +        (1 << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID);
> > +
> 
> Do we need compat machinery for this?

Don't think so, microvm has no versioned machine types anyway.

> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c

> >      [FEAT_KVM_HINTS] = {
> >          .type = CPUID_FEATURE_WORD,
> >          .feat_names = {
> > -            "kvm-hint-dedicated", NULL, NULL, NULL,
> > +            "kvm-hint-dedicated", "host-phys-bits", NULL, NULL,

> > -    DEFINE_PROP_BOOL("host-phys-bits", X86CPU, host_phys_bits, false),

> > -    if (cpu->host_phys_bits) {
> > +    if (cpu->env.features[FEAT_KVM_HINTS] &
> > +        (1 << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID)) {
> >          /* The user asked for us to use the host physical bits */
> >          phys_bits = host_phys_bits;
> >          if (cpu->host_phys_bits_limit &&
> 
> I think we still want to key this one off host_phys_bits
> so it works for e.g. hyperv emulation too.

I think that should be the case.  The chunks above change the
host-phys-bits option from setting cpu->host_phys_bits to setting
the FEAT_KVM_HINTS bit.  That should also happen with hyperv emulation
enabled, and the bit should also be visible to the guest then, just at
another location (base 0x40000100 instead of 0x40000000).

take care,
  Gerd

