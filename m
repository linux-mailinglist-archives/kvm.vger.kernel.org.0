Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F9F5E5EB5
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 11:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiIVJhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 05:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIVJhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 05:37:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C775D1EA0
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 02:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663839436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7oj+2jI4YoPXJ6AGpx0nxqfwe010tlDa7ZqwHb2xxQ0=;
        b=XPJ61wDh9ZCq2P/yWNIdscfx3Y3R+XYGXO/8u8QuPkE+jUL2rOM7bHLQPoIO6TPFBTJa0k
        QO0A9kZeBeuDBYXCFAXgGeSOZHGh7+yWdlPX6BVjkHsWTWs647IbaRhwN4r1JwxcJyI99B
        EsvaKN/HWB+zx7ZZkB/5Fat13UxQ9kc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-0vaBM6gePO25M4Y0MC3gcg-1; Thu, 22 Sep 2022 05:37:12 -0400
X-MC-Unique: 0vaBM6gePO25M4Y0MC3gcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64E2A294EDF2;
        Thu, 22 Sep 2022 09:37:12 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BD86C15BA8;
        Thu, 22 Sep 2022 09:37:12 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id C22C91800084; Thu, 22 Sep 2022 11:37:10 +0200 (CEST)
Date:   Thu, 22 Sep 2022 11:37:10 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] x86: add etc/phys-bits fw_cfg file
Message-ID: <20220922093710.q3pxbxljdhu4a4yw@sirius.home.kraxel.org>
References: <20220922084356.878907-1-kraxel@redhat.com>
 <20220922044906-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922044906-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 04:55:16AM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 22, 2022 at 10:43:56AM +0200, Gerd Hoffmann wrote:
> > In case phys bits are functional and can be used by the guest (aka
> > host-phys-bits=on) add a fw_cfg file carrying the value.  This can
> > be used by the guest firmware for address space configuration.
> > 
> > This is only enabled for 7.2+ machine types for live migration
> > compatibility reasons.
> > 
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> I'm curious why you decided to switch from a cpuid flag to fw cfg.

The kernel people didn't like the cpuid approach.

> I guess firmware reads fw cfg anyway.

Correct.

> But would the guest kernel then need to load a fw cfg driver very
> early to detect this, too?

Nope, the guest kernel can just work with the address space layout
created by the firmware.  The firmware can for example reserve a
larger 64-bit mmio window in case there is enough address space for
that.  So it programs the bridge windows etc accordingly, qemu
generates matching acpi tables and the kernel picks up the changes
via _CRS.

> > +void fw_cfg_phys_bits(FWCfgState *fw_cfg)
> > +{
> > +    X86CPU *cpu = X86_CPU(first_cpu);
> > +    uint64_t phys_bits = cpu->phys_bits;
> > +
> > +    if (cpu->host_phys_bits) {
> > +        fw_cfg_add_file(fw_cfg, "etc/phys-bits",
> > +                        g_memdup2(&phys_bits, sizeof(phys_bits)),
> > +                        sizeof(phys_bits));
> > +    }
> > +}
> 
> So, this allows a lot of flexibility, any phys_bits value at all can now
> be used. Do you expect a use-case for such a flexible mechanism?  If
> this ends up merely repeating CPUID at all times then we are just
> creating confusion.

Yes, it'll just repeat CPUID.  Advantage is that the guest gets the
information it needs right away.

Alternatively I could create a "etc/reliable-phys-bits" bool.
The firmware must consult both fw_cfg and cpuid then.

take care,
  Gerd

