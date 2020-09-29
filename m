Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15F27BC76
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 07:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgI2Fc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 01:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI2Fc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 01:32:57 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3398C061755;
        Mon, 28 Sep 2020 22:32:57 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y13so3557917iow.4;
        Mon, 28 Sep 2020 22:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXa4y005IEeOvzIT3W6I4v2oKckcccuU1eVEnGaDAlc=;
        b=uphl8BBgBXNgae9iRJPAk4R/297HosgOCKhG0E6oNc5io33fgnIlc6nrmkdqRYNMmD
         0C9UtzAobhgYVT+oDb/IqPNbVtEC0DqT+jy7dzEp+8+R8FgZFqzNWY72i2OVGl9NVtkv
         ZVgJtZ1iPG3po3nLLzJUZ2fDa3YFXEZES3lS+IHg6gD43BBQvEfXBktUQTGFi0Dcyga0
         DxP+ymMj+0+oPv8SK7jAv+ntVx6MEhVTkHT0SRDgYdu/2AruZH4BAZUVdkIZb3We8/ZI
         yfuA7zgc0rvPILREgae/Op4Eq1zLNRhWEFkcnO9Pv2Ev4D2cr7xHfrgn1iYYzHnbE0KH
         RZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXa4y005IEeOvzIT3W6I4v2oKckcccuU1eVEnGaDAlc=;
        b=geuc6lQbTId8B2EGQyIiahD04/k1hX0zKPVEtrusdcWELt1WpOn2XfzpjvfPm7Rf9V
         HgLCX2TKRJtPyBW3eIeyDFfd8mWgh1WvADacL19mMGxqwRbqBKAAWLULDZ9pNsv2kDME
         +/A2f2OAfy7258imJtApy2qjo3ApE0UyojvJaXUshM8n6JlG4DBWEy/mHoE4I1SLp/2p
         INCJzqHUoe72tmm13ktnKvBkgm6BpwHplZO9CyBcUmPm9pEyUCIaR9ZgMXCs3MmfRskc
         9EfXmjvowpecAC5kuNA6UrVbVYt92Q3636vJgbZ5uOTOHo7uYBSIZFg7ctuIOkjRCPPn
         yJmg==
X-Gm-Message-State: AOAM532YyNvJhmvIHPnyJn7RS1HdALK4kUsLnIbpXmdjSXM3L0xJMi1H
        9PpbvTQ8jYIDa9bKdpqnc6ougprv3GzYUbinYkQ=
X-Google-Smtp-Source: ABdhPJxZpHlrnLEIs/czxllBMNiG+x5bzGnVpX45Dsh326meI6e5PLAP1kjReMovSvCNhgrVhbKI1869DZfUOI6W0Wk=
X-Received: by 2002:a02:8782:: with SMTP id t2mr1643382jai.56.1601357576879;
 Mon, 28 Sep 2020 22:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200928083047.3349-1-jiangshanlai@gmail.com> <20200928162417.GA28825@linux.intel.com>
In-Reply-To: <20200928162417.GA28825@linux.intel.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 29 Sep 2020 13:32:45 +0800
Message-ID: <CAJhGHyAYXARENZ7OExenZO6tiWAaSQ=jzEG+7j0rjCsa9e5-dA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] kvm/x86: intercept guest changes to X86_CR4_LA57
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 12:24 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Sep 28, 2020 at 04:30:46PM +0800, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> >
> > When shadowpaping is enabled, guest should not be allowed
> > to toggle X86_CR4_LA57. And X86_CR4_LA57 is a rarely changed
> > bit, so we can just intercept all the attempts to toggle it
> > no matter shadowpaping is in used or not.
> >
> > Fixes: fd8cb433734ee ("KVM: MMU: Expose the LA57 feature to VM.")
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> >   No test to toggle X86_CR4_LA57 in guest since I can't access to
> >   any CPU supports it. Maybe it is not a real problem.
>


Hello

Thanks for reviewing.

> LA57 doesn't need to be intercepted.  It can't be toggled in 64-bit mode
> (causes a #GP), and it's ignored in 32-bit mode.  That means LA57 can only
> take effect when 64-bit mode is enabled, at which time KVM will update its
> MMU context accordingly.
>

Oh, I missed that part which is so obvious that the patch
seems impertinent.

But X86_CR4_LA57 is so fundamental that it makes me afraid to
give it over to guests. And it is rarely changed too. At least,
there is no better reason to give it to the guest than
intercepting it.

There might be another reason that this patch is still needed with
an updated changelog.

When a user (via VMM such as qemu) launches a VM with LA57 disabled
in its cpuid on a LA57 enabled host. The hypervisor, IMO, needs to
intercept guest's changes to X86_CR4_LA57 even when the guest is still
in the non-paging mode. Otherwise the hypervisor failed to detective
such combination when the guest changes paging mode later.

Anyway, maybe it is still not a real problem.

Thanks
Lai
