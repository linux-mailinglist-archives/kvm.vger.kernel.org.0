Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9AB40654D
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhIJBlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhIJBlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:41:17 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E853C061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 18:40:07 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g184so381837pgc.6
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 18:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nw1XuRphVhmebMWySqSgscevY/3iUqmrlDyrnRFrHKA=;
        b=S5YmgtMQkCudzpyQLODl0re3GrSSO7j8nvdeHfwyXadBlaer9vIIbVnMHIal02p63S
         yowjL4wta0GDTHwMhyqa3fDnfZMZJc3SXllkdzD2rbKtxX8QHqU7aHWiL8iFVSYDEexp
         Y5TBwOxhymRo4xijghBmEvLxS1Ut7eQnIb0/QbJ1nubo+kg2T6n0+ssFpPowyf1NqBeP
         fymykYwYYMll6MN3tm4j9V3CTS/arPS7Y/NBlRT+dXecnnp+MkGFxJWQuL12PIT84yOl
         T84piIPgK4V3IDM6TMYMBjo1XXaSjReUCGT/8bUwsNN1EcampT+IhcGoljfYGcQA7MWU
         BfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nw1XuRphVhmebMWySqSgscevY/3iUqmrlDyrnRFrHKA=;
        b=hiB+frsucYl4jlzNGne+iWWQtBCE5kB9kErXO9zI0eWh57b5S+DiM6BL+jHiVjIASC
         Di+IzYg31Ds8YTCJrwvye8neaTuVnpAELeyd/fCii4Zti4cYOfINxKrFhzel+rxHKl53
         83A/frTJjsL1ZD79JOBf8ErRpmfpVcfL+rB/8lvykzwfaERk+ciJf9pAxizIjB5e5dC9
         MyyQg+Jxd+vAzRl9mZfbhvsE8pScriBUgOdH7d/dRiOWZpjGCOdtHxYXq1F153EJrAmH
         CqzQzH4OFw4Gz7nHV41wr88t9gnewcryg8NAdH37/vhyJ4k+Qtsj2ou1QL20Dt9YzUOW
         anMA==
X-Gm-Message-State: AOAM533a6hTCMBmDbYNSdQXoL2wmsYgxWSixqvkLfXW2XGRHWZdsfuq8
        44Y3T5MOtzQsvUAlFg0P0TvPhQ==
X-Google-Smtp-Source: ABdhPJzhcYHZJOzZKYUuqzZuCXltDD1Cm6NY9QEhexyPCdpteDd8b5Dr69VBiaHl1B9IRYv7mchLXw==
X-Received: by 2002:a05:6a00:aca:b029:392:9c79:3a39 with SMTP id c10-20020a056a000acab02903929c793a39mr5815686pfl.57.1631238006377;
        Thu, 09 Sep 2021 18:40:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y13sm3326392pfb.115.2021.09.09.18.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 18:40:05 -0700 (PDT)
Date:   Fri, 10 Sep 2021 01:40:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V7] KVM, SEV: Add support for SEV intra host migration
Message-ID: <YTq3cRq5tYbopgSd@google.com>
References: <20210902181751.252227-1-pgonda@google.com>
 <20210902181751.252227-2-pgonda@google.com>
 <YTqirwnu0rOcfDCq@google.com>
 <CAA03e5Ek=puWCXc+cTi-XNe02RXJLY7Y6=cq1g-AyxEan_RG2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5Ek=puWCXc+cTi-XNe02RXJLY7Y6=cq1g-AyxEan_RG2A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021, Marc Orr wrote:
> > > +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
> > > +{
> > > +     struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> > > +     struct file *source_kvm_file;
> > > +     struct kvm *source_kvm;
> > > +     int ret;
> > > +
> > > +     ret = svm_sev_lock_for_migration(kvm);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (!sev_guest(kvm) || sev_es_guest(kvm)) {
> > > +             ret = -EINVAL;
> > > +             pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
> >
> > Linux generally doesn't log user errors to dmesg.  They can be helpful during
> > development, but aren't actionable and thus are of limited use in production.
> 
> Ha. I had suggested adding the logs when I reviewed these patches
> (maybe before Peter posted them publicly). My rationale is that if I'm
> looking at a crash in production, and all I have is a stack trace and
> the error code, then I can narrow the failure down to this function,
> but once the function starts returning the same error code in multiple
> places now it's non-trivial for me to deduce exactly which condition
> caused the crash. Having these logs makes it trivial. However, if this
> is not the preferred Linux style then so be it.

I don't necessarily disagree, but none of these errors conditions should so much
as sniff production.  E.g. if userspace invokes this on a !KVM fd or on a non-SEV
source, or before guest_state_protected=true, then userspace has bigger problems.
Ditto if the dest isn't actual KVM VM or doesn't meet whatever SEV-enabled/disabled
criteria we end up with.

The mismatch in online_vcpus is the only one where I could reasonablly see a bug
escaping to production, e.g. due to an orchestration layer mixup.

For all of these conditions, userspace _must_ be aware of the conditions for success,
and except for guest_state_protected=true, userspace has access to what state it
sent into KVM, e.g. it shouldn't be difficult for userspace dump the relevant bits
from the src and dst without any help from the kernel.

If userspace really needs kernel help to differentiate what's up, I'd rather use
more unique errors for online_cpus and guest_state_protected, e.g. -E2BIG isn't
too big of a strecth for the online_cpus mismatch.
