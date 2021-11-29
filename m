Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B50462542
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhK2WhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbhK2Wg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:36:29 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A88C093B58
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 13:21:15 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id o14so13230693plg.5
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 13:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vTbh7aMdkVU2cnIaX6D7qbh+Z4p8232l+qU6dAcs9x4=;
        b=G8XdUOVk/Af3Ui5DfIB3/ikbiJ7GY2s5wvC/HOIFhBIam5Pz3ldQ1H2ynr7JbPqp3O
         re3/JvzVtv6dYnjmNS5qWXoHBgzVFMAOT17e4a/6b2T1JCq4P5JIuYipQshBjPAFI1ps
         dNiRrBNWw0FFjytFmACBGtSXefn/ZQEULpkb5qz4P0VaAzdTJ09x46CtfN9jtnl5JuPz
         uAsRyehQ466wFzPv6BTeODZsr7Pe69VmeLGsy66HyBwk8mp3qmuFkCnv4fwx4+D6nfjK
         nYPUtn9pnZ2QXPCS16n9u7qgUN2RT6ra+5F2LZuNmzZQFMtfTFPfYgIRlhg6o5MwFX+C
         wdiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vTbh7aMdkVU2cnIaX6D7qbh+Z4p8232l+qU6dAcs9x4=;
        b=O45QeMkjYZ+Jg7ZD1zseQJ5hGfC6qRFKRz+t312qAOriSz1apRhfyNmJDNSJE6fOmx
         VE9vfxCwURH/YZr5PBIhH+gA1pQ6XUb57eyMP2ESuT04SFoH3K6g23sMKNkV/lfSg5Ht
         8rwmdn1nUFLEN8t4L/Gj/8j9MyI5ir7UxXj1K/54S/PWGnRggYuw5c0mhS+GeeBZ35wo
         Oqv9LkC/q9wBKRJK4kgiRC3LhPVi0ekgSZJfs+jPGzGSQ3Jz9e8l7N+ANdk0Tnv/Rp7n
         +l0WNkBPFHQkvSGY0XJYFVEKvOSNap4aeycBZ/JYc+lTUG4tdO+Mzb2MMYuxOQiEL81I
         WNcQ==
X-Gm-Message-State: AOAM5336NPkkgLIfK2yIV+hAk829ldcRBgMyEXTJR3i8RNk9xcUEvxvE
        A60v1BS8AY0KNv0VWIWlEBq0GA==
X-Google-Smtp-Source: ABdhPJwYounno/EIO+D542MzhtWgmcz65LU2sUa/hZMVgFVjaQp4rGDaoomCk7tGf9A2eVM9efxzpg==
X-Received: by 2002:a17:902:64c2:b0:141:c171:b99b with SMTP id y2-20020a17090264c200b00141c171b99bmr62232728pli.55.1638220874835;
        Mon, 29 Nov 2021 13:21:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b4sm18810116pfl.60.2021.11.29.13.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 13:21:14 -0800 (PST)
Date:   Mon, 29 Nov 2021 21:21:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 23/59] KVM: x86: Allow host-initiated WRMSR to set
 X2APIC regardless of CPUID
Message-ID: <YaVERrcOp9ctdj8Y@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <63556f13e9608cbccf97d356be46a345772d76d3.1637799475.git.isaku.yamahata@intel.com>
 <87fsrkja4j.ffs@tglx>
 <d449a4c2-131d-5406-b7a2-7549bacc02f9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d449a4c2-131d-5406-b7a2-7549bacc02f9@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021, Paolo Bonzini wrote:
> On 11/25/21 20:41, Thomas Gleixner wrote:
> > On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> > > Let userspace, or in the case of TDX, KVM itself, enable X2APIC even if
                                            ^^^^^^^^^^

> > > X2APIC is not reported as supported in the guest's CPU model.  KVM
> > > generally does not force specific ordering between ioctls(), e.g. this
> > > forces userspace to configure CPUID before MSRs.  And for TDX, vCPUs
> > > will always run with X2APIC enabled, e.g. KVM will want/need to enable
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > X2APIC from time zero.
      ^^^^^^^^^^^^^^^^^^^^^
> > 
> > This is complete crap. Fix the broken user space and do not add
> > horrible hacks to the kernel.
> 
> tl;dr: I agree that it's a userspace issue but "configure CPUID before MSR"
> is not the issue (in fact QEMU calls KVM_SET_CPUID2 before any call to
> KVM_SET_MSRS).

Specifically for TDX, it's not a userspace issue.  To simplify other checks and
to report sane values for KVM_GET_MSRS, KVM forces X2APIC for TDX guests when the
vCPU is created, before its exposed to usersepace.  The bit about not forcing
specific ordering is justification for making the change independent of TDX,
i.e. to call out that APIC_BASE is different from every other MSR, and is even
inconsistent in its own behavior since illegal transitions are allowed when
userspace is stuffing the MSR.

IMO, this patch is valid irrespective of TDX.  It's included in the TDX series
because TDX support forces the issue.

That said, an alternative for TDX would be do handle this in kvm_lapic_reset()
now that the lAPIC RESET flows are consolidated.  Back when this patch was first
written, that wasn't really an option.
