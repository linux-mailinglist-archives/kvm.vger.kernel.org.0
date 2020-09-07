Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A5C25F985
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 13:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgIGLdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 07:33:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33045 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729075AbgIGLcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 07:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599478360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xh0jDnNxVb+gfwupJzhZeFoIO1CEsK8pGfyr2cjqVvU=;
        b=OZVVkJw8kuTqFgBvxTDNYwpSoZmScm8But66DOUgcGmKaYXQZY49r7zfpbWWycxWjOZd3Z
        aeXie8gKlhvtq9BPd4c54FSDtgKoCJ5b0kRduQpn3tJkAlPQiQBNnhWyz4uKOodUVYmJSQ
        dTnxWzOw9SiYWCHO2IoHBfj5wEegywY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-ApVzV26VN-KXqJye8FydkQ-1; Mon, 07 Sep 2020 07:32:39 -0400
X-MC-Unique: ApVzV26VN-KXqJye8FydkQ-1
Received: by mail-wm1-f71.google.com with SMTP id k12so4851764wmj.1
        for <kvm@vger.kernel.org>; Mon, 07 Sep 2020 04:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xh0jDnNxVb+gfwupJzhZeFoIO1CEsK8pGfyr2cjqVvU=;
        b=pmNhzj8XA0VJZLtfpKW4PGo8LtW4Gb5OnvhJVI6wrcqLX7toCdFLHE2gZ4VERGe8O+
         184DLM9BzTnhT5wL6qg0WeX/2Biruh6yArIww1/8bLlfGPlXiCLvLs4BAHirZKd8C18j
         2r9FLq7sRDOyqv6V2RQppLmgc8Fiuc/2mw7imbAorat2Cbog7mclMs+F0QLLXrp93w0d
         79qsr9mt9msRtXbE4tI68AO8dFMdEIyF2zIhpcQgjvRk/lYA8sv9EcZWsNiqUT79teWN
         nrzCFZx+fwY7fHgb40oY/gIKylVlL8OqghKrJUp4ZO94EBvictcCrENSIBQLL9P/nZCy
         rGpA==
X-Gm-Message-State: AOAM533Or5mdWzzaOv+hKmmB10AH6aTNV5sjlD0+OKqrV2Ngr3u9PDK2
        /O33STM50EBo/YWIYDFFC8vUsiflgb+jkLCIDnl2PvTbLqD1M2k086qPSMguCnPzDJSVb4ggr2V
        Rfur3F68bSzji
X-Received: by 2002:a5d:680b:: with SMTP id w11mr22519860wru.73.1599478358045;
        Mon, 07 Sep 2020 04:32:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl1gZsmRJ09H74DIxRgRGxBon6iiq3rf0F1B1g7lolsEq76lgKe1Sng/BGlf4cPxzJJxlFmQ==
X-Received: by 2002:a5d:680b:: with SMTP id w11mr22519838wru.73.1599478357797;
        Mon, 07 Sep 2020 04:32:37 -0700 (PDT)
Received: from redhat.com ([192.117.173.58])
        by smtp.gmail.com with ESMTPSA id j14sm28032781wrr.66.2020.09.07.04.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 04:32:36 -0700 (PDT)
Date:   Mon, 7 Sep 2020 07:32:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200907072829-mutt-send-email-mst@kernel.org>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
 <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
 <20200904160008.GA2206@sjchrist-ice>
 <874koanfsc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874koanfsc.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 07, 2020 at 10:37:39AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Fri, Sep 04, 2020 at 09:29:05AM +0200, Gerd Hoffmann wrote:
> >>   Hi,
> >> 
> >> > Unless I'm mistaken, microvm doesn't even support PCI, does it?
> >> 
> >> Correct, no pci support right now.
> >> 
> >> We could probably wire up ecam (arm/virt style) for pcie support, once
> >> the acpi support for mictovm finally landed (we need acpi for that
> >> because otherwise the kernel wouldn't find the pcie bus).
> >> 
> >> Question is whenever there is a good reason to do so.  Why would someone
> >> prefer microvm with pcie support over q35?
> >> 
> >> > If all of the above is true, this can be handled by adding "pci=lastbus=0"
> >> > as a guest kernel param to override its scanning of buses.  And couldn't
> >> > that be done by QEMU's microvm_fix_kernel_cmdline() to make it transparent
> >> > to the end user?
> >> 
> >> microvm_fix_kernel_cmdline() is a hack, not a solution.
> >> 
> >> Beside that I doubt this has much of an effect on microvm because
> >> it doesn't support pcie in the first place.
> >
> > I am so confused.  Vitaly, can you clarify exactly what QEMU VM type this
> > series is intended to help?  If this is for microvm, then why is the guest
> > doing PCI scanning in the first place?  If it's for q35, why is the
> > justification for microvm-like workloads?
> 
> I'm not exactly sure about the plans for particular machine types, the
> intention was to use this for pcie in QEMU in general so whatever
> machine type uses pcie will benefit. 
> 
> Now, it seems that we have a more sophisticated landscape. The
> optimization will only make sense to speed up boot so all 'traditional'
> VM types with 'traditional' firmware are out of
> question. 'Container-like' VMs seem to avoid PCI for now, I'm not sure
> if it's because they're in early stages of their development, because
> they can get away without PCI or, actually, because of slowness at boot
> (which we're trying to tackle with this feature). I'd definitely like to
> hear more what people think about this.

I suspect microvms will need pci eventually. I would much rather KVM
had an exit-less discovery mechanism in place by then because
learning from history if it doesn't they will do some kind of
hack on the kernel command line, and everyone will be stuck
supporting that for years ...

> >
> > Either way, I think it makes sense explore other options before throwing
> > something into KVM, e.g. modifying guest command line, adding a KVM hint,
> > "fixing" QEMU, etc... 
> >
> 
> Initially, this feature looked like a small and straitforward
> (micro-)optimization to me: memory regions with 'PCI hole' semantics do
> exist and we can speed up access to them. Ideally, I'd like to find
> other 'constant memory' regions requiring fast access and come up with
> an interface to create them in KVM but so far nothing interesting came
> up...

True, me neither.

> -- 
> Vitaly

