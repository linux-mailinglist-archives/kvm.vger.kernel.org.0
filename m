Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A051C1C77AE
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 19:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgEFRUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 13:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgEFRUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 13:20:00 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99CFC061A0F
        for <kvm@vger.kernel.org>; Wed,  6 May 2020 10:19:59 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id t2so2026698lfc.3
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 10:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yWSACSjzxxkhsSEtqMbD8V41P6+c8r2yedDDvx7UmMw=;
        b=N8Mq87uUKXwMAqRZXQM6vqhW3Ak1jAsFB0DpLlnaLpz/joEle+KhMMgv3GI1N0ayt+
         z+JBj1N2/zt/g2fuwaLvRADn/baFP5VK1iPBCh/PdJ5fPZnXQn837LM9hEHYlb4x0y4W
         oFWztmEjzcxqIxkfd3D3uJtSx9NgD1nao25s5gwpQLAT92vS8VgZO8hyOYB9S9qsYVGW
         9iiDOUJrdSNE3cdOGY0A01o9KfygqIgiGxQJjdtTzlN0RJ8S42FPgcmPa8DXy0N5CFYR
         7/rkm+zCf55MnIe6WGM8janiIy++qCzQKHCR4QcqUZawWSxaDa29//409Q7pZDzHRGWy
         VG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yWSACSjzxxkhsSEtqMbD8V41P6+c8r2yedDDvx7UmMw=;
        b=NAI10PgBqLQzXaZN0b275CTmx4RayGX2DKr9OfPlZYduy6gT/a3X3qQJnx7g0ctPZF
         9UKeLacCIfPiIAIQkTXzGpLcwo9E/zlm3ok56+fg/E8adC2nMtoUyHZzeJ7St1UbRvl5
         yXlg36IlAUBtSV0xNclvmqAMbhE8zAedC5i11Lu35Y7qRqR5h6cZG8D62CkVpzGqkGZb
         cwdZ11WkYm4GgSUTgGHQ2FDHBZAkF5dWNzRXvHwdDp3Gi7WJ1MSCf9jmh/d8zrVghptL
         pyyQhBvVRE7UNjqFu4KJwwVEX63CCF3Y9iCghLcEw5NSDxVz/rdl0ULa+6Z3oQYCjPsR
         7HjQ==
X-Gm-Message-State: AGi0Pub8RwHNB1DQ+16D4uIrEsiTGTEKo0Y42HEgXV1WsfBxxg9m29sW
        dnQQku/eB/e0o7rwGp4NCtmk5+OOL8vBrH/o1KeYIw==
X-Google-Smtp-Source: APiQypJeemtehaLs0H+3fTfw7shcfXNmdPij2e4z7Psgsw7CAFEtTtUSt8NYA5q+G9FeDIUigLxtpHQre1N2R2Cxx6A=
X-Received: by 2002:a19:700b:: with SMTP id h11mr1286446lfc.62.1588785597955;
 Wed, 06 May 2020 10:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200505232201.923-1-oupton@google.com> <262881d0-cc24-99c2-2895-c5cbdc3487d0@redhat.com>
 <20200506152555.GA3329@linux.intel.com> <1f91d445-c3f3-fe35-3d65-0b7e0a6ff699@redhat.com>
 <20200506164856.GE3329@linux.intel.com>
In-Reply-To: <20200506164856.GE3329@linux.intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 6 May 2020 10:19:47 -0700
Message-ID: <CAOQ_QsgFfQO9QBj9o7NVm9K5JvwhGHi8p+yM6rwzJzOEpe2rGA@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: get vmcs12 pages before checking pending interrupts
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 6, 2020 at 9:49 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, May 06, 2020 at 06:00:03PM +0200, Paolo Bonzini wrote:
> > On 06/05/20 17:25, Sean Christopherson wrote:
> > >>
> > >> The patch is a bit ad hoc, I'd rather move the whole "if
> > >> (kvm_request_pending(vcpu))" from vcpu_enter_guest to vcpu_run (via a
> > >> new function).
> > > It might make sense to go with an ad hoc patch to get the thing fixed, then
> > > worry about cleaning up the pending request crud.  It'd be nice to get rid
> > > of the extra nested_ops->check_events() call in kvm_vcpu_running(), as well
> > > as all of the various request checks in (or triggered by) vcpu_block().
> >
> > Yes, I agree that there are unnecessary tests in kvm_vcpu_running() if
> > requests are handled before vcpu_block and that would be a nice cleanup,
> > but I'm asking about something less ambitious.
> >
> > Can you think of something that can go wrong if we just move all
> > requests, except for KVM_REQ_EVENT, up from vcpu_enter_guest() to
> > vcpu_run()?  That might be more or less as ad hoc as Oliver's patch, but
> > without the code duplication at least.
>
> I believe the kvm_hv_has_stimer_pending() check in kvm_vcpu_has_events()
> will get messed up, e.g. handling KVM_REQ_HV_STIMER will clear the pending
> bit.  No idea if that can interact with HLT though.
>
> Everything else looks ok, but I didn't exactly do a thorough audit.
>
> My big concern is that we'd break something and never notice because the
> failure mode would be a delayed interrupt or poor performance in various
> corner cases.  Don't get me wrong, I'll all for hoisting request handling
> out of vcpu_enter_guest(), but if we're goint to risk breaking things I'd
> prefer to commit to a complete cleanup.

My main motivation for adding the duplicate code was to avoid
introducing new failures. I agree that a larger cleanup is in order,
but didn't want to unintentionally break things at the moment :)

--
Thanks,
Oliver
