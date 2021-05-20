Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE2C38B84E
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 22:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhETUXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 16:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbhETUXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 16:23:34 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE38C061761
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 13:22:11 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g18so11557536pfr.2
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 13:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0kHUdBz9cuFf2vqxAG3Pc3rwFQXdOdHIp65C2b34hQI=;
        b=dEbYyegVNncUJt/SGH/oedIn1Atx8b0ygTK3+FvgB7epKgdgC9Dr0BsUcCu0DxDONy
         nOdkHnRrc3EBQFs4KDXJ2K2uXczhWNN1TvwwnypClxAMhk225QAwV9ZAelVesgPg4gEr
         31hxAUaGEeNvn6+euCcc++hR4Xgw1fdJ0bpe9gijjtkWvhSXD/tHe5v0KrdOqvGiZ5NY
         P6OGPy2PbFW56a9XMokoEoRNtE8kgoqlejBFIcr1DWdGvlU9ZNvYJlWfmLN53bOLE3SM
         zedriT9bXOz/nINIc4gsQfjJhak9v4hEdPX055ElQy+ecm56rMsB3X+mLdo/0q44EAj4
         wjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0kHUdBz9cuFf2vqxAG3Pc3rwFQXdOdHIp65C2b34hQI=;
        b=Yivu37zSPRty50W47ZNMsp2Ykw7cHNl5HPH0+H28KlYq/ShBg38XyzeLX264dpNFt6
         Q42Ppk2aB6KD0GQR9KpyN6Ft+xuvEzTNjpeS591CIdKK9uZsLNXka6xTN/5o82ZOUGmc
         6mnuazGvbu4/kRamZiaHDZzVNC8NnnlYWNWkWFBauZgLpF8NasuS2p3Xu/G1tbrKBJ54
         Y0WsyHwG/bV4oMZ+6dbdTp3YLKTHfYp2SsZQTF57A9ViO0r4CrDL9QdVo86RDfqjJK1A
         Trv3NF9XSdJTbCdOX44Y4Ksv+X9y0EtRLeBBQOh3jdU+PlSxql8OZ16JPW199AqWYItt
         A/Tg==
X-Gm-Message-State: AOAM530NZi6sYSq3hJPHmp5mse6BxJol3OPM5Ia9+1k6B8T1rwLIoM6y
        hgDrAmOHsTnZ6M1Vhssl2hpDaQ==
X-Google-Smtp-Source: ABdhPJxE3b2rco77LJIbWnsRpfZ7UydHf0CesLXTf2wlREWqTk3U//LCQG9XIv1gDO7Oo1lfvMXjYw==
X-Received: by 2002:a63:224d:: with SMTP id t13mr6260936pgm.283.1621542130812;
        Thu, 20 May 2021 13:22:10 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x203sm2612206pfc.86.2021.05.20.13.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:22:10 -0700 (PDT)
Date:   Thu, 20 May 2021 20:22:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
Message-ID: <YKbE7m40GnSRZsr1@google.com>
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
 <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
 <324d9228-03e9-0fe2-59c0-5e41e449211b@amd.com>
 <YKa1jduPK9JyjWbx@google.com>
 <YKa4I0cs/8lyy0fN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKa4I0cs/8lyy0fN@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021, Sean Christopherson wrote:
> On Thu, May 20, 2021, Sean Christopherson wrote:
> > On Mon, May 17, 2021, Tom Lendacky wrote:
> > > On 5/14/21 6:06 PM, Peter Gonda wrote:
> > > > On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> > > >>
> > > >> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
> > > >> exit code and parameters fail. Since the VMGEXIT instruction can be issued
> > > >> from userspace, even though userspace (likely) can't update the GHCB,
> > > >> don't allow userspace to be able to kill the guest.
> > > >>
> > > >> Return a #GP request through the GHCB when validation fails, rather than
> > > >> terminating the guest.
> > > > 
> > > > Is this a gap in the spec? I don't see anything that details what
> > > > should happen if the correct fields for NAE are not set in the first
> > > > couple paragraphs of section 4 'GHCB Protocol'.
> > > 
> > > No, I don't think the spec needs to spell out everything like this. The
> > > hypervisor is free to determine its course of action in this case.
> > 
> > The hypervisor can decide whether to inject/return an error or kill the guest,
> > but what errors can be returned and how they're returned absolutely needs to be
> > ABI between guest and host, and to make the ABI vendor agnostic the GHCB spec
> > is the logical place to define said ABI.
> > 
> > For example, "injecting" #GP if the guest botched the GHCB on #VMGEXIT(CPUID) is
> > completely nonsensical.  As is, a Linux guest appears to blindly forward the #GP,
> > which means if something does go awry KVM has just made debugging the guest that
> > much harder, e.g. imagine the confusion that will ensue if the end result is a
> > SIGBUS to userspace on CPUID.
> > 
> > There needs to be an explicit error code for "you gave me bad data", otherwise
> > we're signing ourselves up for future pain.
> 
> More concretely, I think the best course of action is to define a new return code
> in SW_EXITINFO1[31:0], e.g. '2', with additional information in SW_EXITINFO2.
> 
> In theory, an old-but-sane guest will interpret the unexpected return code as
> fatal to whatever triggered the #VMGEXIT, e.g. SIGBUS to userspace.  Unfortunately
> Linux isn't sane because sev_es_ghcb_hv_call() assumes any non-'1' result means
> success, but that's trivial to fix and IMO should be fixed irrespective of where
> this goes.

One last thing (hopefully): Erdem pointed out that if the GCHB GPA (or any
derferenced pointers within the GHCB) is invalid or is set to a private GPA
(mostly in the context of SNP) then the VMM will likely have no choice but to
kill the guest in response to #VMGEXIT.

It's probably a good idea to add a blurb in one of the specs explicitly calling
out that #VMGEXIT can be executed from userspace, and that before returning to
uesrspace the guest kernel must always ensure that the GCHB points at a legal
GPA _and_ all primary fields are marked invalid. 
