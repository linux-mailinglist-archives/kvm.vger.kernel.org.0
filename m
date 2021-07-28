Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9A13D9398
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 18:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhG1Qv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 12:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhG1Qv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 12:51:57 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88368C061764
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 09:51:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id e5so3406156pld.6
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 09:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qCPT4bVwwR8ai3a6eA6/fF0tOyNcgHz50ZuIx8a534o=;
        b=dMzmTUSnosm/iHkWAoP9DVdTxjicL604f4Cb691mO0xLlWzl1lxDi0I5v80JbvapeL
         xi7SV7RTFrxsT600ehMokUmTeLg69m4nWFIpMWkg5/2VylXavXWLdX5m12NRv7gkznCv
         LC/keunwPko8qkM4Cmm42n8CIWUrHhCwdMeMeXWpqNnZIcwuJdV6LFztW+QUDQvG4HoM
         j2CKMaWMy2LQzHH7CioAkmfb4cSiv23lZ8yFvage+0fcOi5z88WDNwpPrk5Swv8kQucn
         wUSgw6uLYoqWEUM+7P/obhiyEnM4qy/4wUiSdayne+tI4zwFp/m09ycflePra7mYOZvu
         8Nyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qCPT4bVwwR8ai3a6eA6/fF0tOyNcgHz50ZuIx8a534o=;
        b=g4Lni1xtHbZlJ3FkKjS4iw1YN+IPSAjFPNoZC0OJxusH7uCf0oRBcs4qJnhCBXoxvQ
         ebSVx2Wb6Wx9Ooz5ZBz8R1oFaUg9/C6VAtqidOcv17sokLPNKMJtZPORZS2u5od9RXEW
         QS5p5rr8usswvnJA4D087fg4QuMToG2rx7LRccTSlwiUFqiju3J6QK73N2pnYgj93gLm
         8v44NDO5eZeIfVvdKInZXhFxFbLhwBidQiey6Khp3SWK3WVl+o0C7+aF4IQigxy+L9Yl
         mNPKieVluuRRTBrnCIhEvhUcK+3eeftCeQHe0POOqc9MDik0u+e6Pqku07HWt/Re9vf1
         ucMg==
X-Gm-Message-State: AOAM530g66zku9oxJ46NsXjVPR13Po5ZIPcwPV52YOq4GKMHFjyQ2qGJ
        lXyRtzZ6Zg9L6lwnkgOo22apng==
X-Google-Smtp-Source: ABdhPJyDcd4jgGC6QwVVtEOI+2Yz7a+SUlYoO1hC9Alm5zD0P5RC7YiblpIcYybXHIGTC3dFf27Kug==
X-Received: by 2002:a63:cd4d:: with SMTP id a13mr707167pgj.364.1627491114753;
        Wed, 28 Jul 2021 09:51:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f16sm276873pgb.51.2021.07.28.09.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:51:54 -0700 (PDT)
Date:   Wed, 28 Jul 2021 16:51:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v2 00/69] KVM: X86: TDX support
Message-ID: <YQGLJrvjTNZAqU61@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <0d453d76-11e7-aeb9-b890-f457afbb6614@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d453d76-11e7-aeb9-b890-f457afbb6614@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Paolo Bonzini wrote:
> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> > * Patch organization
> > The patch 66 is main change.  The preceding patches(1-65) The preceding
> > patches(01-61) are refactoring the code and introducing additional hooks.
> > 
> > - 01-12: They are preparations. introduce architecture constants, code
> >           refactoring, export symbols for following patches.
> > - 13-40: start to introduce the new type of VM and allow the coexistence of
> >           multiple type of VM. allow/disallow KVM ioctl where
> >           appropriate. Especially make per-system ioctl to per-VM ioctl.
> > - 41-65: refactoring KVM VMX/MMU and adding new hooks for Secure EPT.
> > - 66:    main patch to add "basic" support for building/running TDX.
> > - 67:    trace points for
> > - 68-69:  Documentation
> 
> Queued 2,3,17-20,23,44-45, thanks.

I strongly object to merging these two until we see the new SEAMLDR code:

  [RFC PATCH v2 02/69] KVM: X86: move kvm_cpu_vmxon() from vmx.c to virtext.h
  [RFC PATCH v2 03/69] KVM: X86: move out the definition vmcs_hdr/vmcs from kvm to x86

If the SEAMLDR code ends up being fully contained in KVM, then this is unnecessary
churn and exposes code outside of KVM that we may not want exposed (yet).  E.g.
setting and clearing CR4.VMXE (in the fault path) in cpu_vmxon() may not be
necessary/desirable for SEAMLDR, we simply can't tell without seeing the code.
