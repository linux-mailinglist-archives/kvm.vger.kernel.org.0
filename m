Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8543D2487
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 15:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhGVMoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 08:44:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231924AbhGVMop (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 08:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626960320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JAnmeuIfQdncCUiW75D8IzEpkqgkah2ZNrMDpLBYjTo=;
        b=iLlI69Nmr/bfh+f/nL4Jl2NViZ7djwp10TLqaUW2YNfMGymStQd/x/pCCweC3401OZSrZy
        5H4Xh4q2bKCMbvckuCm+Ox/l+N1u+Uu5fhzsmfXvJ5QqKlZcn1l40q3+70LtJJi1d098Yz
        W2I5dLbpJn3Hi2R4Kh0T99xrtAq0nC4=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-4wTF94F7P4eAtdKMZ_rSgA-1; Thu, 22 Jul 2021 09:25:19 -0400
X-MC-Unique: 4wTF94F7P4eAtdKMZ_rSgA-1
Received: by mail-il1-f200.google.com with SMTP id s18-20020a92cbd20000b02901bb78581beaso3548308ilq.12
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 06:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JAnmeuIfQdncCUiW75D8IzEpkqgkah2ZNrMDpLBYjTo=;
        b=c71iKWSJoAsREb96oPa51ZrYM6Lvo7XWgRYcewgkmSrDMO0teYvoPG5bCOWuX3+w75
         FKy/c1PxMM/k3/UToxgssLKnu+umIqnPEDYSXA6cp5iuyhAL+5d3iOc59ALJSJM3PUpN
         3yN1pSTAREPrgrhAQegAA6S0a3nrR7xjhiSEnJvT3OKru30Mxkh/J53JziLXSWHpdjPL
         ICrA06h3vEQf8WAweUPbHLtd8wzL/7oPfDDNilCsV/Ej3XCl4EmmuopkuSlWYGA8FCuh
         jyTwnH8Febs1beYQcJt5vRB8/Nw8bw9bJ9QVA8v+VgyRB0YP89Vmx/CKP0NayhIRi/t0
         bPjQ==
X-Gm-Message-State: AOAM530Fl4s/aZ/ZlJydCXg56wICpC94hMZXeFgNmClben4ihgHdGKZV
        p7JQ/S/eRQefhWmTXkvD4dTlCDProhCZwtwXNxDpOKJrV6k68jVx7tfUYjRmgut5QcCORQUlMLX
        wMJcho99THNfM
X-Received: by 2002:a6b:f101:: with SMTP id e1mr17328421iog.118.1626960318897;
        Thu, 22 Jul 2021 06:25:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzO7B6+/GK3ldKKhKw6OpJsBYn9h5NNBp2v0iNDfsc4BXVWjBxmWixYMqcWppyKDhuCURsoJA==
X-Received: by 2002:a6b:f101:: with SMTP id e1mr17328405iog.118.1626960318688;
        Thu, 22 Jul 2021 06:25:18 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id z6sm14874865ilz.54.2021.07.22.06.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 06:25:18 -0700 (PDT)
Date:   Thu, 22 Jul 2021 15:25:15 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        will@kernel.org
Subject: Re: [PATCH 00/16] KVM: arm64: MMIO guard PV services
Message-ID: <20210722132515.y66qi23r6ty3anax@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210721214243.dy6d644yznuopuqx@gator>
 <874kcm3byd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kcm3byd.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021 at 11:00:26AM +0100, Marc Zyngier wrote:
> On Wed, 21 Jul 2021 22:42:43 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > On Thu, Jul 15, 2021 at 05:31:43PM +0100, Marc Zyngier wrote:
> > > KVM/arm64 currently considers that any memory access outside of a
> > > memslot is a MMIO access. This so far has served us very well, but
> > > obviously relies on the guest trusting the host, and especially
> > > userspace to do the right thing.
> > > 
> > > As we keep on hacking away at pKVM, it becomes obvious that this trust
> > > model is not really fit for a confidential computing environment, and
> > > that the guest would require some guarantees that emulation only
> > > occurs on portions of the address space that have clearly been
> > > identified for this purpose.
> > 
> > This trust model is hard for me to reason about. userspace is trusted to
> > control the life cycle of the VM, to prepare the memslots for the VM,
> > and [presumably] identify what MMIO ranges are valid, yet it's not
> > trusted to handle invalid MMIO accesses. I'd like to learn more about
> > this model and the userspace involved.
> 
> Imagine the following scenario:
> 
> On top of the normal memory described as memslots (which pKVM will
> ensure that userspace cannot access),

Ah, I didn't know that part.

> a malicious userspace describes
> to the guest another memory region in a firmware table and does not
> back it with a memslot.
> 
> The hypervisor cannot validate this firmware description (imagine
> doing ACPI and DT parsing at EL2...), so the guest starts using this
> "memory" for something, and data slowly trickles all the way to EL0.
> Not what you wanted.

Yes, I see that now, in light of the above.

> 
> To ensure that this doesn't happen, we reverse the problem: userspace
> (and ultimately the EL1 kernel) doesn't get involved on a translation
> fault outside of a memslot *unless* the guest has explicitly asked for
> that page to be handled as a MMIO. With that, we have a full
> description of the IPA space contained in the S2 page tables:
> 
> - memory described via a memslot,
> - directly mapped device (GICv2, for exmaple),
> - MMIO exposed for emulation
> 
> and anything else is an invalid access that results in an abort.
> 
> Does this make sense to you?

Now I understand better, but if we're worried about malicious userspaces,
then how do we protect the guest from "bad" MMIO devices that have been
described to it? The guest can request access to those using this new
mechanism.

Thanks,
drew

