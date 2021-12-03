Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C699467B18
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhLCQSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 11:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhLCQSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 11:18:11 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E820EC061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 08:14:47 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so5535933pju.3
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 08:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mDEuCH3n+yniaEStC/bTIvAFijRLrGRV0ZCyXMk9t/M=;
        b=oqUYSbutqJteauH4QzJUU1tERxwyPAPDs3EM1sc0ukykTNiWq39o1dov0dglm/5QqV
         XvTnRgBdPVRgoGKaQMRYn0HK7ai7kM+8aWEPTo8HUUtJdLm/9D3J1VVTChAGdn4AHd98
         VEmIkkCkynqxDfng4apt3z7nBS65wq8VEEzI3bh+gcihDy7bYlq0nsQDqYn64U4lge4M
         QMmchmZ50jnEjuZnsoeCW2OoPLJMXrUiSPcQT+/h8Nrn66ZzDGtonMlqo3AqPjre3K5/
         JPYmUMKkRqHh31DXge2eRfYWyhhTqGB036sKzb5T6taryxdgDuDPqD/B0oUffI2cWSfe
         k5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mDEuCH3n+yniaEStC/bTIvAFijRLrGRV0ZCyXMk9t/M=;
        b=KAXXv3M6o7cdqSYqgZCKzPGApMH4gZSrTVK+OXjEDt6bpLBNPjbjPoBplNkDPe1e00
         vwAzGWfoqdCfdKmO4GhXEka9QRY8OSVL4uyE9vCYqEsnKmuUZ2ooMkICGkmzcnCJtKcb
         IQPAXww2Yt8oTJ5nI7dma8zx9wJQdhtyzfNmNqI+ZV6SlgA+lZ9LL0EdyIZtkLmG0WD9
         8OHGwEPSQ8qRUDJL1oijBmox8GS27mo4Qui5r5c8MrZCznEKFN38Ek7uU4tEkMqbc1ED
         ZRIzTYzRA0zoevRiX+Ou5y8tk8ObEGB3RMU+ZVX0DvwSWOZpW8LmDh29rtKQk/Aoq0C5
         mfSw==
X-Gm-Message-State: AOAM530hUVhRuUAEipPeAaIChmMtW9B0uNtU4siAM0LukTw+NqOpg9Gm
        F9REdEWE7CDa+QuR45777ehj2Q==
X-Google-Smtp-Source: ABdhPJxvvSjINFqQcAHf2+Clt4J5Cn7W5SqPzyCyKfYyq/bvZNquHePCmEG8d2EWGpoFnpbBVV59ag==
X-Received: by 2002:a17:90b:17c4:: with SMTP id me4mr15106820pjb.15.1638548086685;
        Fri, 03 Dec 2021 08:14:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v38sm2826654pgl.38.2021.12.03.08.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 08:14:45 -0800 (PST)
Date:   Fri, 3 Dec 2021 16:14:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 14/59] KVM: x86: Add vm_type to differentiate
 legacy VMs from protected VMs
Message-ID: <YapCclOiQXWGXVEr@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <60a163e818b9101dce94973a2b44662ba3d53f97.1637799475.git.isaku.yamahata@intel.com>
 <87tug0jbno.ffs@tglx>
 <YaUPZj4ja5FY7Fvh@google.com>
 <20211201193737.GB1166703@private.email.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201193737.GB1166703@private.email.ne.jp>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021, Isaku Yamahata wrote:
> On Mon, Nov 29, 2021 at 05:35:34PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Thu, Nov 25, 2021, Thomas Gleixner wrote:
> > > On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > >
> > > > Add a capability to effectively allow userspace to query what VM types
> > > > are supported by KVM.
> > > 
> > > I really don't see why this has to be named legacy. There are enough
> > > reasonable use cases which are perfectly fine using the non-encrypted
> > > muck. Just because there is a new hyped feature does not make anything
> > > else legacy.
> > 
> > Yeah, this was brought up in the past.  The current proposal is to use
> > KVM_X86_DEFAULT_VM[1], though at one point the plan was to use a generic
> > KVM_VM_TYPE_DEFAULT for all architectures[2], not sure what happened to that idea.
> > 
> > [1] https://lore.kernel.org/all/YY6aqVkHNEfEp990@google.com/
> > [2] https://lore.kernel.org/all/YQsjQ5aJokV1HZ8N@google.com/
> 
> Currently <feature>_{unsupported, disallowed} are added and the check is
>  sprinkled and warn in the corresponding low level tdx code.  It helped to
>  detect dubious behavior of guest or qemu.

KVM shouldn't log a message or WARN unless the issue is detected at a late sanity
check, i.e. where failure indicates a KVM bug.  Other than that, I agree that KVM
should reject ioctls() that directly violate the rules of a confidential VM with
an appropriate error code.  I don't think KVM should reject everything though,
e.g. if the guest attempts to send an SMI, dropping the request on the floor is
the least awful option because we can't communicate an error to the guest without
making up our own architecture, and exiting to userspace with -EINVAL from deep
in KVM would be both painful to implement and an overreaction since doing so would
likely kill the guest.

> The other approach is to silently ignore them (SMI, INIT, IRQ etc) without
> such check.  The pros is, the code would be simpler and it's what SEV does today.
> the cons is, it would bes hard to track down such cases and the user would
> be confused.  For example, when user requests reset/SMI, it's silently ignored.
> The some check would still be needed.
> Any thoughts?
> 
> -- 
> Isaku Yamahata <isaku.yamahata@gmail.com>
