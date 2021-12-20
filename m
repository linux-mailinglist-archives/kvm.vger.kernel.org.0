Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A5947A792
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 11:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhLTKHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 05:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230251AbhLTKHd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 05:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639994853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OSLdQYtaAE+KxJRSEto8PUIHyVRplaPjVQGwutQdkcE=;
        b=aELoH+PK9Set3nyv7QM9GGlP+ddlB0jBmt2/DRS9IyFk/vOjQueaPyFxRyPVEawpjsPrg3
        g2Ivd7H12H2TGITMQVQ5M7eAhU6ODPsy6DQwpgQAw9XiaBrczAq6SerFcHdwNJURS5mFgd
        jGnHBbJgtqNJYcbaEZbAiuNMAtIuJ7o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-b6qaWDCBNJq6V4Ib_j0Jmw-1; Mon, 20 Dec 2021 05:07:32 -0500
X-MC-Unique: b6qaWDCBNJq6V4Ib_j0Jmw-1
Received: by mail-wm1-f72.google.com with SMTP id l6-20020a05600c4f0600b0033321934a39so3133558wmq.9
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 02:07:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OSLdQYtaAE+KxJRSEto8PUIHyVRplaPjVQGwutQdkcE=;
        b=EWeoIR/LSW3CBYxzmOtpiyvneDlC7eR7AxmDmZ301jEUDJBsP45LkabdtpD+520/Sx
         QdAdyFxeU1kH4I5bj6zBzvZ5BCm5ePVaDWu+d/SuhU2mKqqlwx1R6MhVf670ETVFRBVP
         mcvZYX/VlDBbUPX3DxNwxjks/LGGXeRSAOu1nre2ksYxBp4YaQzUCjOO4abbLLVQ+ZWj
         r2DYIfewUbjr84ak3m6RyZ9mTRFHGKQTPD5v3jdKMwgkmFfZ+ULnPALBafYHp2e6F3uS
         o4V2CWiBsFhfMYrWoHZan3vL33QZ3qeG4ISeeMUrwgFeNjGRRx7W9C5ioVZRTT0lEUGH
         FKTw==
X-Gm-Message-State: AOAM530DGuLOYtt/JbgNBWgD+i2ZHjK1I2SFdnGc/LoTHbwpMdugonuP
        t04TFVdFoDI7+7q3hwwcP9nThwEnF2z1nIovSuJxUp9e6jR/3VaqWDGef0FbG/TO1mYYQpPugQT
        MlH0nbcBMlkJb
X-Received: by 2002:a05:600c:1ca4:: with SMTP id k36mr13574499wms.169.1639994850820;
        Mon, 20 Dec 2021 02:07:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJws/VOBgVZgMhOehZp/Gf5UnrmrB2XNJXzkxVBaGeg306WSIgO2FP9gd/nistGckWlx/GS0uQ==
X-Received: by 2002:a05:600c:1ca4:: with SMTP id k36mr13574474wms.169.1639994850595;
        Mon, 20 Dec 2021 02:07:30 -0800 (PST)
Received: from xz-m1.local ([85.203.46.164])
        by smtp.gmail.com with ESMTPSA id p2sm6071801wrs.112.2021.12.20.02.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 02:07:29 -0800 (PST)
Date:   Mon, 20 Dec 2021 18:07:22 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] intel_iommu: Fix irqchip / X2APIC configuration
 checks
Message-ID: <YcBV2uSVTSm3pvVX@xz-m1.local>
References: <20211209220840.14889-1-dwmw2@infradead.org>
 <20211209220840.14889-4-dwmw2@infradead.org>
 <Ybr9Cn7GPKbm/rzL@xz-m1.local>
 <ebaa70df2b126e3cdded33d0281828cd9cd6de04.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ebaa70df2b126e3cdded33d0281828cd9cd6de04.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17, 2021 at 04:51:20PM +0000, David Woodhouse wrote:
> On Thu, 2021-12-16 at 16:47 +0800, Peter Xu wrote:
> > Hi, David,
> > 
> > On Thu, Dec 09, 2021 at 10:08:40PM +0000, David Woodhouse wrote:
> > > We don't need to check kvm_enable_x2apic(). It's perfectly OK to support
> > > interrupt remapping even if we can't address CPUs above 254. Kind of
> > > pointless, but still functional.
> > 
> > We only checks kvm_enable_x2apic() if eim=on is set, right?  I mean, we can
> > still enable IR without x2apic even with current code?
> > 
> > Could you elaborate what's the use scenario for this patch?  Thanks in advance.
> 
> You can have IR, EIM *and* X2APIC if kvm_enable_x2apic() fails. You
> just can't have any CPUs with an APIC ID > 254.
> 
> But qemu is going to bail out *anyway* if you attempt to have CPUs with
> APIC IDs above 254 without the corresponding kernel-side support, so
> there's no need to check it here.

Ah OK.

> 
> > > The check on kvm_enable_x2apic() needs to happen *anyway* in order to
> > > allow CPUs above 254 even without an IOMMU, so allow that to happen
> > > elsewhere.
> > > 
> > > However, we do require the *split* irqchip in order to rewrite I/OAPIC
> > > destinations. So fix that check while we're here.
> > > 
> > > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > > Reviewed-by: Peter Xu <peterx@redhat.com>
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> > 
> > I think the r-b and a-b should be for patch 2 not this one? :)
> > 
> 
> Yes, I think I must have swapped those round. Thanks.
> 
> > > ---
> > >  hw/i386/intel_iommu.c | 7 +------
> > >  1 file changed, 1 insertion(+), 6 deletions(-)
> > > 
> > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> > > index bd288d45bb..0d1c72f08e 100644
> > > --- a/hw/i386/intel_iommu.c
> > > +++ b/hw/i386/intel_iommu.c
> > > @@ -3760,15 +3760,10 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
> > >                                                ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
> > >      }
> > >      if (s->intr_eim == ON_OFF_AUTO_ON && !s->buggy_eim) {
> > > -        if (!kvm_irqchip_in_kernel()) {
> > > +        if (!kvm_irqchip_is_split()) {
> > 
> > I think this is okay, but note that we'll already fail if !split in
> > x86_iommu_realize():
> > 
> >     bool irq_all_kernel = kvm_irqchip_in_kernel() && !kvm_irqchip_is_split();
> > 
> >     /* Both Intel and AMD IOMMU IR only support "kernel-irqchip={off|split}" */
> >     if (x86_iommu_ir_supported(x86_iommu) && irq_all_kernel) {
> >         error_setg(errp, "Interrupt Remapping cannot work with "
> >                          "kernel-irqchip=on, please use 'split|off'.");
> >         return;
> >     }
> 
> OK, then perhaps the entire check is redundant?

Yes, maybe.

It also reminded me that this is the only place that we used the "buggy_eim"
variable.  If we drop this chunk, that flag will become meaningless.

If we look back, it seems to decides whether we should call kvm_enable_x2apic()
at all, so as to be compatible with old qemus.  Please see commit fb506e701e
("intel_iommu: reject broken EIM", 2016-10-17).

hw_compat_2_7 has:

    { "intel-iommu", "x-buggy-eim", "true" },

It means kvm_enable_x2apic() (at least before commit c1bb5418e3 of yours)
should be skipped for 2.7 or older version of QEMU binaries.

Now after commit c1bb5418e3 we'll unconditionally call kvm_enable_x2apic() in
x86_cpu_load_model() anyway, even if x-buggy-eim=on.  IIUC it violates with the
original purpose of commit fb506e701e.

However maybe it's not necessary to maintain that awkward/buggy compatibility
at all for those old qemu binaries.  I can hardly imagine someone uses vIOMMU
2.7- versions for production purposes, and for relying on that buggy behavior
to work.

To summarize: I'm wondering whether we should also drop buggy-eim as a whole..

Thanks,

-- 
Peter Xu

