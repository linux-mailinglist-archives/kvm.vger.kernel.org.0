Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE0146286F
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 00:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhK2Xl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 18:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbhK2Xl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 18:41:56 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD309C061756
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 15:38:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q16so17694767pgq.10
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 15:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kimin07IyQujzwbNieuCZAXwjj1roojWjqX5HWur5aU=;
        b=Wsw+rXmhVk+A+ci/dpCKpRKXxCMuyKgJPmFHurEFyKZ1yoeuVHrUluGgbdWdjPa7ww
         XjV2FHLl/REIVyA1Za6yBUNq0K1pfFutbciD8Bbk6FGFtmfKBLU5dpIa1uWOqby0H3Bu
         lBbCkoN4MgRL3J+IoLPGm3HZRHVo4SxPx9IlZqxwHl3sfdM3315DHroq8tvCugZSAMmC
         E/GexI7mIdflziFoqFed8pWZF7aJwarZ7cjLHowO8Jz6WGTMx8VnVbwx7BqhRG+jvx1P
         i8ZZo0/9HZHIpHjZ6G6kvT8Ux5kQjxQqA+aAzWjUBZUvEHoTZd5jfjyAmEmzxM5nWEgV
         AEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kimin07IyQujzwbNieuCZAXwjj1roojWjqX5HWur5aU=;
        b=Qd1oLrhLrdTCX4NSLflv3i0k0SYkVUKsQtJe3ahJkgRIJM9GizVan6r54hy5Ws0eDh
         QxZZcgg60ymaJtnMRRkAthX9nFhD0e2tzo1Vl8UM/6Dmsfm1rm8HZy2rNJqbnWPfzPPd
         +9lPbWy6nGmNBlbZd2LlMV7tQ4yeQr79DuZtvP3a4GOXrAUMbE5OTYpmsIBOaYPW/Rht
         nzU99QbSOj53ZQ2gX/yia6xb24WOa3ozHPj+4yQcaDKbGvKiMMhVqp9Dm4kNP7sqt5mp
         7auXHKDZZg3TRc0q8GWSNLzRcJXVpcpLybwa/p5V8+NJx4GCI6vxjkpiaclxCUWXkuuf
         +saA==
X-Gm-Message-State: AOAM531kbuiciVC/jzIp0VSVW56Ysx2VRH3MYuyQd2DT406hil+d+44G
        WA4PZAbFhBaumhEcbaT22EspSg==
X-Google-Smtp-Source: ABdhPJwpzUNbdUuRzeXMckQ0oWkaWO8uUHzEVuQzZ1oSekyb/3R3wksSbGFHSGirj3qfxf4HuEayhw==
X-Received: by 2002:a05:6a00:1348:b0:481:179c:ce9b with SMTP id k8-20020a056a00134800b00481179cce9bmr41985324pfu.27.1638229117199;
        Mon, 29 Nov 2021 15:38:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c18sm18945196pfl.201.2021.11.29.15.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:38:36 -0800 (PST)
Date:   Mon, 29 Nov 2021 23:38:33 +0000
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
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 54/59] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
Message-ID: <YaVkeZalN5wkd9uL@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <5ba3573c8b82fcbdc3f3994f6d4d2a3c40445be9.1637799475.git.isaku.yamahata@intel.com>
 <875ysghrp8.ffs@tglx>
 <741df444-5cd0-2049-f93a-c2521e4f426d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <741df444-5cd0-2049-f93a-c2521e4f426d@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Paolo Bonzini wrote:
> On 11/25/21 22:05, Thomas Gleixner wrote:
> > You can argue that my request is unreasonable until you are blue in
> > your face, it's not going to lift my NAK on this.
> 
> There's no need for that.  I'd be saying the same, and I don't think it's
> particularly helpful that you made it almost a personal issue.
> 
> While in this series there is a separation of changes to existing code vs.
> new code, what's not clear is _why_ you have all those changes. These are
> not code cleanups or refactorings that can stand on their own feet; lots of
> the early patches are actually part of the new functionality.  And being in
> the form of "add an argument here" or "export a function there", it's not
> really easy (or feasible) to review them without seeing how the new
> functionality is used, which requires a constant back and forth between
> early patches and the final 2000 line file.
> 
> In some sense, the poor commit messages at the beginning of the series are
> just a symptom of not having any meat until too late, and then dropping it
> all at once.  There's only so much that you can say about an
> EXPORT_SYMBOL_GPL, the real thing to talk about is probably the thing that
> refers to that symbol.
> 
> If there are some patches that are actually independent, go ahead and submit
> them early.  But more practically, for the bulk of the changes what you need
> to do is:
> 
> 1) incorporate into patch 55 a version of tdx.c that essentially does
> KVM_BUG_ON or WARN_ON for each function.  Temporarily keep the same huge
> patch that adds the remaining 2000 lines of tdx.c
> 
> 2) squash the tdx.c stub with patch 44.
> 
> 3) gather a strace of QEMU starting up a TDX domain.
> 
> 4) figure out which parts of the code are needed to run until the first
> ioctl.  Make that a first patch.

Hmm, I don't think this approach will work as well as it did for SEV when applied
at a per-ioctl granuarity, I suspect several patches will end up quite large.   I
completely agree with the overall idea, but I'd encourage the TDX folks to have a
finer granularity where it makes sense, e.g. things like the x2APIC behavior,
immutable TSC, memory management, etc... can probably be sliced up into separate
patches.

> 5) repeat step 4 until you have covered all the code
> 
> 5) Move the new "KVM: VMX: Add 'main.c' to wrap VMX and TDX" (which also
> adds the tdx.c stub) as possible in the series.
> 
> 6) Move each of the new patches as early as possible in the series.
> 
> 7) Look for candidates for squashing (e.g. commit messages that say it's
> "used later"; now the use should be very close and the two can be merged).
> Add to the commit message a note about changes outside VMX.

Generally speaking, I agree.  For the flag exposion, I 100% agree that setting
the flag in TDX, adding it in x86 is best done in a signal patch, and handling
all side effects is best done in a single patch.  

But for things like letting debug TDs access registers, I would prefer not to
actually squash the two (or more) patches.  I agree that two related patches need
to be contiguous in the series, but I'd prefer that things with non-trivial changes,
especially in common code, are kept separate.

> The resulting series may not be perfect, but it would be a much better
> starting point for review.
> 
> Paolo
