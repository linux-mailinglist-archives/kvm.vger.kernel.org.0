Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FC4389A06
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 01:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhESXpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 19:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhESXps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 19:45:48 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D319EC06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 16:44:27 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f22so9625086pgb.9
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 16:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nZuNfGfiKyXKRGv3YKg4ctxDIT6bECxQ0f3JGFBP+Jc=;
        b=Sgx3LcjYq6ETYEDY47hsYdaRrCnGN5F+wvbCKhFTmXMWw0u20UAbMuFGPG9jqIUIDU
         P7xy6mX2t46w8BN7ogPNyFnieYyRV1A5wNHWtckVTaOalBCdY2k7i8vqSzUaeIOv1HJm
         SdhnOlnT85Ku+HNVywQC6S0Q0CSpGbSV0jji0h4u0H9ZZUbw2Oc2PaGvP3QqVTLp8v0a
         ndubfFE0z+CIhyCbHHksip7jVF0c4qS1bEXgLcb/8gbO/zaMys9Od89i9374vQ0nkfkK
         fpPfQX8A8bK+ARVFMCi1+CZ1hnIlV089tUlC1ZxUt4UrYtf3X/fOG88O+/RFSOPkzxu2
         UgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nZuNfGfiKyXKRGv3YKg4ctxDIT6bECxQ0f3JGFBP+Jc=;
        b=Szi/4Nt4vNloy1BkTC/aFCCViAad6ToLCZumeru7ueOYc4pisaP1g8uTULhFdDzQe1
         8Cc16b1DhYROT2xABeXynQYn8nQ6WF4Q5szgZA+jdwrUS4lKsOInA+La93o69G6+CikI
         vXBqCqiJArywhPZZqjfkQ2OgUSR/4j3EmkM9MU2bQfFw2seS8MYr9Q/2xFwrLyq+ctrW
         E/TQON/HvIVDJSesZbZcvWWTM1f6SNoeXyam1cUxrKSICBjej7aA7E+fs7B46IM9cvHV
         ANx694R3U29ZkTNs2zs5JdpaDdJnmomRDcmEow/Q9104mDfXxfV177Hta0jFDnoZ9Oei
         z5WA==
X-Gm-Message-State: AOAM531Njxs918DB9CvHffwsW5ah5mqfInYZiDWnIwF5KqW+mxNo84xI
        8fXgant54wuBpCY9cF451fjkVw==
X-Google-Smtp-Source: ABdhPJxDvzU0EhqoO2ANcJc4uzxhDerfang0h/wnVFWCCixnjLqJ1xzPwQO0cV2EkX0CMe3MbW7o5Q==
X-Received: by 2002:a63:ba03:: with SMTP id k3mr1612845pgf.81.1621467867151;
        Wed, 19 May 2021 16:44:27 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v14sm364605pgl.86.2021.05.19.16.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 16:44:26 -0700 (PDT)
Date:   Wed, 19 May 2021 23:44:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        thomas.lendacky@amd.com, the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <YKWi1iR4weMzpeC2@google.com>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <86701a5e-87b5-4e73-9b7a-557d8c855f89@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86701a5e-87b5-4e73-9b7a-557d8c855f89@www.fastmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, Andy Lutomirski wrote:
> On Wed, May 12, 2021, at 6:15 AM, Borislav Petkov wrote:
> > On Fri, Apr 23, 2021 at 03:58:43PM +0000, Ashish Kalra wrote:
> > > +static inline void notify_page_enc_status_changed(unsigned long pfn,
> > > +						  int npages, bool enc)
> > > +{
> > > +	PVOP_VCALL3(mmu.notify_page_enc_status_changed, pfn, npages, enc);
> > > +}
> > 
> > Now the question is whether something like that is needed for TDX, and,
> > if so, could it be shared by both.
> 
> The TDX MapGPA call can fail, and presumably it will fail if the page is not
> sufficiently quiescent from the host's perspective.

Barring a guest bug, e.g. requesting a completely non-existent page, MapGPA
shouldn't fail.  The example in the the GHCI:

  Invalid operand – for example, the GPA may be already mapped as a shared page.

makes no sense to me.  An already-mapped page would be an -EBUSY style error,
not an invalid operand, and IIRC, I explicitly lobbied against allowing the VMM
to return "try again" precisely because it's impossible for the guest to handle
in a sane manner.  If the physical page is in a state that requires stalling the
vCPU, then the VMM is supposed to do exactly that, not punt the problem to the
guest.

Maybe we should get stronger language into the GHCI?

> It seems like a mistake to me to have a KVM-specific hypercall for this that
> cannot cleanly fail.
