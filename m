Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC43234AD6
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 20:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387786AbgGaSX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 14:23:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23472 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387695AbgGaSXz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 14:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596219833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FNpcdsYn9B2kxIJXPQv8FKNGYI77IPCjCGNgFBGg9TU=;
        b=jAOAxME0pF6xAYDA2Jdxd1ujI7EihvrXu8ApNU2yhrk25VgOeP5Z/QjlJ6E1FbWcbi7pxU
        kyEfMbMSOSmZK/4LygESZju4fiRFMGF9kaaBWcCIQHQcJJ12brI/nw5NoEYoFm2ie6xhh+
        GgoktZ18Pr6v5fKOPCMd8LV8vx6DxXc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-sSMvz-nzO8euI5_g7tMsdQ-1; Fri, 31 Jul 2020 14:23:50 -0400
X-MC-Unique: sSMvz-nzO8euI5_g7tMsdQ-1
Received: by mail-lf1-f71.google.com with SMTP id j22so6377383lfg.21
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 11:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FNpcdsYn9B2kxIJXPQv8FKNGYI77IPCjCGNgFBGg9TU=;
        b=bjrtPhX5yfELEyUNjXP/8LA6gYNjedK/Sqp+Q3zdSzhwUgSKFawL2FbCZ7hatk/vET
         nKvn8OytOe8tIZeAAowXXOJzjv2tOQNB6PFXQGIvFRND5Rl/DtSZ8WTRV+q0RpNY3VlG
         IfTrgpde1S7LrorRzGF4oq004e+c70Uz2CX1hF8ZuQAC8Y0bKh+HhoSdg+ZsyARbz2ok
         9negLYjziTUMiJFOj6c91CwnDZAq6nZXDCDF9zZAGqQASs5mqcJrY2GkrnsNUNrKDx5g
         C9N2HDVCNg8BVf+eyQ8kMHWa0SZB5ZRMr+yfDfHlYByX3KPbBk0iHoYvugcD5z82ZnY5
         u8Jg==
X-Gm-Message-State: AOAM531imENiuPxBrdvqxaoZFlJIZWdMF2dZQXvS/5dzACdr4TiayNWY
        GNmQ1GcjYlFvDneVrZpPM+EsLmPk3DhrrqlkvCIJ+EYwx+aPkrS6V67MhHwYZJz3k1fQbpXAG0F
        bKLlI/HEq/eRR8OkJA+ecEvJzSTQn
X-Received: by 2002:a2e:9b92:: with SMTP id z18mr2632607lji.364.1596219828920;
        Fri, 31 Jul 2020 11:23:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4Ant7fRiaPouV8KSdgTTmMLlIjwSIMUXrC6ApBECDS2mEDf33c4K66gE4HFkxWsG1WUkVTH6tWl9p/Sj0yXU=
X-Received: by 2002:a2e:9b92:: with SMTP id z18mr2632592lji.364.1596219828575;
 Fri, 31 Jul 2020 11:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200730193510.578309-1-jusual@redhat.com> <CAHp75VcyRjAr3ugmAWYcKMrAeea6ioQOPfJnj-Srntdg_W8ScQ@mail.gmail.com>
 <873658kpj2.fsf@vitty.brq.redhat.com>
In-Reply-To: <873658kpj2.fsf@vitty.brq.redhat.com>
From:   Julia Suvorova <jusual@redhat.com>
Date:   Fri, 31 Jul 2020 20:23:37 +0200
Message-ID: <CAMDeoFUO7UqDx05dK3fJBCfWMDCmEJ+K=nVAvvnPZiTz2+gSTg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Use MMCONFIG for all PCI config space accesses
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 11:22 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Andy Shevchenko <andy.shevchenko@gmail.com> writes:
>
> > On Thu, Jul 30, 2020 at 10:37 PM Julia Suvorova <jusual@redhat.com> wrote:
> >>
> >> Using MMCONFIG instead of I/O ports cuts the number of config space
> >> accesses in half, which is faster on KVM and opens the door for
> >> additional optimizations such as Vitaly's "[PATCH 0/3] KVM: x86: KVM
> >> MEM_PCI_HOLE memory":
> >
> >> https://lore.kernel.org/kvm/20200728143741.2718593-1-vkuznets@redhat.com
> >
> > You may use Link: tag for this.
> >
> >> However, this change will not bring significant performance improvement
> >> unless it is running on x86 within a hypervisor. Moreover, allowing
> >> MMCONFIG access for addresses < 256 can be dangerous for some devices:
> >> see commit a0ca99096094 ("PCI x86: always use conf1 to access config
> >> space below 256 bytes"). That is why a special feature flag is needed.
> >>
> >> Introduce KVM_FEATURE_PCI_GO_MMCONFIG, which can be enabled when the
> >> configuration is known to be safe (e.g. in QEMU).
> >
> > ...
> >
> >> +static int __init kvm_pci_arch_init(void)
> >> +{
> >> +       if (raw_pci_ext_ops &&
> >> +           kvm_para_has_feature(KVM_FEATURE_PCI_GO_MMCONFIG)) {
> >
> > Better to use traditional pattern, i.e.
> >   if (not_supported)
> >     return bail_out;
> >
> >   ...do useful things...
> >   return 0;
> >
> >> +               pr_info("PCI: Using MMCONFIG for base access\n");
> >> +               raw_pci_ops = raw_pci_ext_ops;
> >> +               return 0;
> >> +       }
> >
> >> +       return 1;
> >
> > Hmm... I don't remember what positive codes means there. Perhaps you
> > need to return a rather error code?
>
> If I'm reading the code correctly,
>
> pci_arch_init() has the following:
>
>         if (x86_init.pci.arch_init && !x86_init.pci.arch_init())
>                 return 0;
>
>
> so returning '1' here means 'continue' and this seems to be
> correct. (E.g. Hyper-V's hv_pci_init() does the same). What I'm not sure
> about is 'return 0' above as this will result in skipping the rest of
> pci_arch_init(). Was this desired or should we return '1' in both cases?

This is intentional because pci_direct_init() is about to overwrite
raw_pci_ops. And since QEMU doesn't have anything in
pciprobe_dmi_table, it is safe to skip it.

Best regards, Julia Suvorova.

