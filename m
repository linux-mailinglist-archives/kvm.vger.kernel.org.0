Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A810D3B1CC1
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 16:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhFWOnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 10:43:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230061AbhFWOnh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 10:43:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624459280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36Ney60QwLOA5znkwX0SnRwg20FjhKs4Zpxi9/E5Tpw=;
        b=LGvFiRpY9FhDN244Jz1rGzYJxr0fGqGUNvtUZ0+uUj1+RfclZQAlDdyOHaurG+e+xlCe7i
        zkZrWYiKWHTPUnDH3bNvAM5AonZiNPvzFNnrdO195UFAAaBg4rYFlad/L9lQ8E2ybHtQ1y
        uaGNqvVXm+dUrTTwBoKHzqLmPb6CtJc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-qzvgo8cBMJ6L1Y0Gd-fTlw-1; Wed, 23 Jun 2021 10:41:17 -0400
X-MC-Unique: qzvgo8cBMJ6L1Y0Gd-fTlw-1
Received: by mail-wr1-f69.google.com with SMTP id i70-20020adf90cc0000b029011a8a299a4dso1138791wri.17
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 07:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=36Ney60QwLOA5znkwX0SnRwg20FjhKs4Zpxi9/E5Tpw=;
        b=p8Hf4dMaRN7NS/jbyi1hl9pmFxvVyXwXkgVIh8+jsR9wvpX4fCdo8l0bJrQ7zcYSB4
         rx7WIh+aBuh9Vcak6j7glYozLxOys5Cg6evNiQZjJ2qijQBpMNL9EtSM/oX8N9C6pJ7A
         KToD29gqngLetExhiig7n2phozjmRal+q/GMcySWcnjDGgBhmkW3ELvXxV9PSO/PWkIr
         0yxV0pQdlcouBuG7css27dXhihsF++H0qAVCU4PGkKgj+xgdeTrGyFWAQ+Y6XyFubyZn
         rVkEx3N/mYg7erW5CSzTjNDyK90hGW7f+rn8SKbdPSaVfz8vX5iK3SrYrG56jBXFgSM5
         bu0w==
X-Gm-Message-State: AOAM532HDxJOKtKkHaVwplH2ZeXEkUnZMS83pmGsZO+3EJmvWV4p9oxB
        KwtmXJQ5+RoDcra3e301ZyzEiDxLCjH0zGLDQAj2FXmF4SoWCWWu7OrOpa7bfwk+Mk9XvVISN1T
        c2lWrY88yxOYf
X-Received: by 2002:a05:6000:1367:: with SMTP id q7mr422592wrz.306.1624459276293;
        Wed, 23 Jun 2021 07:41:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRRbpbxzOcbllEgwS/pfK7cAIJBOd+/iZk45ykRSCMjl9ZoW8MrMWeylR0rMHwn2MJquAeow==
X-Received: by 2002:a05:6000:1367:: with SMTP id q7mr422570wrz.306.1624459276129;
        Wed, 23 Jun 2021 07:41:16 -0700 (PDT)
Received: from [172.16.0.103] ([5.28.162.59])
        by smtp.gmail.com with ESMTPSA id e2sm247809wrt.29.2021.06.23.07.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 07:41:15 -0700 (PDT)
Message-ID: <5fc502b70a89e18034716166abc65caec192c19b.camel@redhat.com>
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Date:   Wed, 23 Jun 2021 17:41:13 +0300
In-Reply-To: <87pmwc4sh4.fsf@vitty.brq.redhat.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
         <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
         <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
         <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
         <87pmwc4sh4.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-23 at 15:32 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Wed, 2021-06-23 at 16:01 +0300, Maxim Levitsky wrote:
> > > On Wed, 2021-06-23 at 11:39 +0200, Paolo Bonzini wrote:
> > > > On 23/06/21 09:44, Vitaly Kuznetsov wrote:
> > > > > - RFC: I'm not 100% sure my 'smart' idea to use currently-
> > > > > unused HSAVE area
> > > > > is that smart. Also, we don't even seem to check that L1 set
> > > > > it up upon
> > > > > nested VMRUN so hypervisors which don't do that may remain
> > > > > broken. A very
> > > > > much needed selftest is also missing.
> > > > 
> > > > It's certainly a bit weird, but I guess it counts as smart
> > > > too.  It 
> > > > needs a few more comments, but I think it's a good solution.
> > > > 
> > > > One could delay the backwards memcpy until vmexit time, but
> > > > that would 
> > > > require a new flag so it's not worth it for what is a pretty
> > > > rare and 
> > > > already expensive case.
> > > > 
> > > > Paolo
> > > > 
> > > 
> > > Hi!
> > > 
> > > I did some homework on this now and I would like to share few my
> > > thoughts on this:
> > > 
> > > First of all my attention caught the way we intercept the #SMI
> > > (this isn't 100% related to the bug but still worth talking about
> > > IMHO)
> > > 
> > > A. Bare metal: Looks like SVM allows to intercept SMI, with
> > > SVM_EXIT_SMI, 
> > >  with an intention of then entering the BIOS SMM handler manually
> > > using the SMM_CTL msr.
> > >  On bare metal we do set the INTERCEPT_SMI but we emulate the
> > > exit as a nop.
> > >  I guess on bare metal there are some undocumented bits that BIOS
> > > set which
> > >  make the CPU to ignore that SMI intercept and still take the
> > > #SMI handler,
> > >  normally but I wonder if we could still break some motherboard
> > >  code due to that.
> > > 
> > > 
> > > B. Nested: If #SMI is intercepted, then it causes nested VMEXIT.
> > >  Since KVM does enable SMI intercept, when it runs nested it
> > > means that all SMIs 
> > >  that nested KVM gets are emulated as NOP, and L1's SMI handler
> > > is not run.
> > > 
> > > 
> > > About the issue that was fixed in this patch. Let me try to
> > > understand how
> > > it would work on bare metal:
> > > 
> > > 1. A guest is entered. Host state is saved to VM_HSAVE_PA area
> > > (or stashed somewhere
> > >   in the CPU)
> > > 
> > > 2. #SMI (without intercept) happens
> > > 
> > > 3. CPU has to exit SVM, and start running the host SMI handler,
> > > it loads the SMM
> > >     state without touching the VM_HSAVE_PA runs the SMI handler,
> > > then once it RSMs,
> > >     it restores the guest state from SMM area and continues the
> > > guest
> > > 
> > > 4. Once a normal VMexit happens, the host state is restored from
> > > VM_HSAVE_PA
> > > 
> > > So host state indeed can't be saved to VMC01.
> > > 
> > > I to be honest think would prefer not to use the L1's hsave area
> > > but rather add back our
> > > 'hsave' in KVM and store there the L1 host state on the nested
> > > entry always.
> > > 
> > > This way we will avoid touching the vmcb01 at all and both solve
> > > the issue and 
> > > reduce code complexity.
> > > (copying of L1 host state to what basically is L1 guest state
> > > area and back
> > > even has a comment to explain why it (was) possible to do so.
> > > (before you discovered that this doesn't work with SMM).
> > 
> > I need more coffee today. The comment is somwhat wrong actually.
> > When L1 switches to L2, then its HSAVE area is L1 guest state, but
> > but L1 is a "host" vs L2, so it is host state.
> > The copying is more between kvm's register cache and the vmcb.
> > 
> > So maybe backing it up as this patch does is the best solution yet.
> > I will take more in depth look at this soon.
> 
> We can resurrect 'hsave' and keep it internally indeed but to make
> this
> migratable, we'd have to add it to the nested state acquired through
> svm_get_nested_state(). Using L1's HSAVE area (ponted to by
> MSR_VM_HSAVE_PA) avoids that as we have everything in L1's memory.
> And,

Hi!

I think I would prefer to avoid touching guest memory as much
as possible to avoid the shenanigans of accessing it:

For example on nested state read we are not allowed to write guest
memory since at the point it is already migrated, and for setting
nested state we are not allowed to even read the guest memory since
the memory map might not be up to date. Then a malicious guest can
always change its memory which also can cause issues.

Since it didn't work before and both sides of migration need a fix,
adding a new flag and adding hsave area to nested state seems like a
very good thing.

I think though that I would use that smm hsave area just like you
did in the patch, just not save it to the guest memory and migrate
it as a new state.

I would call it something smm_l1_hsave_area or something like
that with a comment explaining why it is needed.

This way we still avoid overhead of copying the hsave area
on each nested entry.

What do you think?

Best regards,
	Maxim Levitsky

> as far as I understand, we comply with the spec as 1) L1 has to set
> it
> up and 2) L1 is not supposed to expect any particular format there,
> it's
> completely volatile.
> 


