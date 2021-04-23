Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A54D36989E
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 19:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhDWRpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 13:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWRpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 13:45:13 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06415C06174A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 10:44:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nk8so10320747pjb.3
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 10:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5RxMUwaNVhtTOHbRnIuRT1gcBdSG2y4cCkyp6iGC3r0=;
        b=EEH3WienSxGlm5zSNY+62F2L+KCXVtwMTq8LpudqnF1poYn0PwrAOsHZUMt1nuhHgb
         m0IWPyypg4mNWp45rG5LnCgEjY7VATzj0tIkcQsfgkTWwCWFOsfnCrhljxezwIdD3rIF
         eJa+uf1ORQvRxImibK8MnhC/LkCS+j6NeKke4Q2xi3Fk/4z8Q+dxqQYSYnp8ODyCryhU
         RjZXZuCiG9wR3EE2a5zT++EEI/2S5FAdnLIGkXUY/wG0vpo4OKXgzcvpSNLr3a2KtGuk
         3KXtcaS5V+zLqXJ7GypwOMWWYjbgmQnjv1HEgDbaMf9CtsA+c7HKdfzRs/x0i+DcGSa3
         Lw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5RxMUwaNVhtTOHbRnIuRT1gcBdSG2y4cCkyp6iGC3r0=;
        b=HDohfr2O4ApGwwgow4LfiJq6or77wJGW6doZl8UkzLCK0HhPfsckHbnu8gySh3x4Uv
         OVbiBSLARf1QRssvMQf/fWTKLe9/7NilUjJUdDqN3vZutbWuMVFS4v6PzSk/RjKuMgdz
         ZwEQ2BhrBTDSkK/VSVMxHss9eL2u49bYPpgR/qZFJAgXREXTJ4t6TQMnvYWYec6OZhNd
         ezV9IppU4RTUzEd7F1LkegGpvkrvLj7oGpvh9g+FqE6QopFmASlXEHsG1y5uYqNyc8Mp
         56DVjnfcBXvucRt7zEKVEjp5xXJXz/TRIBFyUmandd9qceA+3UBOavECrNUMtYSvSSKK
         /3OQ==
X-Gm-Message-State: AOAM532ECMg4a1X2i/6gVGmIHSHrb+r1rueXI2VdlxsXuhsixbHSmZ0W
        RR/CcO3/9l9uxoLvjQ1GmqjZAA==
X-Google-Smtp-Source: ABdhPJzpSxF5Sef9QSagPdb+ZsrKHbcCHJpwTakCb0c8VOrGRNh/3TQJsmnDiO/DyKiyzbyT2w8M5w==
X-Received: by 2002:a17:902:b785:b029:eb:7a1b:5016 with SMTP id e5-20020a170902b785b02900eb7a1b5016mr4831326pls.51.1619199876334;
        Fri, 23 Apr 2021 10:44:36 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m20sm4654058pfk.133.2021.04.23.10.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 10:44:35 -0700 (PDT)
Date:   Fri, 23 Apr 2021 17:44:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve Rutherford <srutherford@google.com>,
        venu.busireddy@oracle.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: invert KVM_HYPERCALL to default to
 VMMCALL
Message-ID: <YIMHgPKnFe9gScQc@google.com>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <76ad1a3f7ce817e8d269a6d58293fc128678affc.1619193043.git.ashish.kalra@amd.com>
 <CALMp9eTTC0kFbRt8TBC3x8N4mDism-xg3xEFSCPGiGc20pZ3ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTTC0kFbRt8TBC3x8N4mDism-xg3xEFSCPGiGc20pZ3ZQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021, Jim Mattson wrote:
> On Fri, Apr 23, 2021 at 9:00 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > KVM hypercall framework relies on alternative framework to patch the
> > VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > apply_alternative() is called then it defaults to VMCALL. The approach
> > works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> > will be able to decode the instruction and do the right things. But
> > when SEV is active, guest memory is encrypted with guest key and
> > hypervisor will not be able to decode the instruction bytes.
> >
> > So invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> > and opt into VMCALL.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  arch/x86/include/asm/kvm_para.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> > index 338119852512..fda2fe0d1b10 100644
> > --- a/arch/x86/include/asm/kvm_para.h
> > +++ b/arch/x86/include/asm/kvm_para.h
> > @@ -19,7 +19,7 @@ static inline bool kvm_check_and_clear_guest_paused(void)
> >  #endif /* CONFIG_KVM_GUEST */
> >
> >  #define KVM_HYPERCALL \
> > -        ALTERNATIVE("vmcall", "vmmcall", X86_FEATURE_VMMCALL)
> > +       ALTERNATIVE("vmmcall", "vmcall", X86_FEATURE_VMCALL)
> >
> >  /* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
> >   * instruction.  The hypervisor may replace it with something else but only the
> > --
> > 2.17.1
> >
> 
> Won't this result in the same problem when Intel implements full VM encryption?

TDX uses yet another opcode, TDCALL, along with a different ABI.  The existing
KVM hypercalls are then tunneled through that ABI.  TDX-specific hypercalls,
which will handle the private vs. shared conversions, will not go through the
KVM defined hypercalls because Intel has defined an ABI for guest/host
communication to handle hypercalls that will be needed by all guest+VMM combos.
E.g. to allow Linux/Windows guests to run on KVM/HyperV/VMware without having to
have additional enlightment for the "basic" functionality.

TL;DR: TDX won't use kvm_hypercall() before apply_alternative().
