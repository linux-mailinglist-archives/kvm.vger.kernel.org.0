Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EAF296DC3
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 13:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463075AbgJWLfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 07:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S463070AbgJWLfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 07:35:21 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D4CC0613D2
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 04:35:20 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id a9so1672297lfc.7
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 04:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=n+nJGJpzd/W8n16INkSYqQkDUkF/oTotGcxcg7bvZAY=;
        b=jU38f+iKMoloRKjrc7spG6UqSiMifftqZ1SZbQrtNvaY7eLmGeolflJh2zjUJkfjpB
         pbtGnihnHQ8QEoGtqlfDer54+Lb8yBXDqz+bNUOMlfGjbD5X74YO6zEmvaYbR5Cud2qd
         Jg7dFHyU0w5YkOSgfSgaN6qpiOp00meBrK7coYuDFGvNMR19c/Q4g+U1ELXlpLXn2kLC
         9eXFgPg66ep/wQgjZBQ9MCAMPcVJvOyOmrb0ix6lBQo6zTPu7OXUgVaUCcgPDYBW0up3
         Q58s6/rzP4gF9rbMqcb5z2I+PhG3uWgO/kQa7rjUWDM7gRNmSLp0rgT7Emh+MTZLoGg+
         k9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=n+nJGJpzd/W8n16INkSYqQkDUkF/oTotGcxcg7bvZAY=;
        b=adqDvx5ZpjMT269T3sm6s4YG2QMNmpQagi98XKg7emr3Jg2vYUSv9gjtF6wf19Isw2
         R3d1qnZsim4v61Po0SI3mPAbcv/9G+4QSmbOn7XV9clMpa1A9lU3U+VaH3QH1nOWe5HA
         hNXhW+MrLsmBSGX+j5IKKEElzaGoCErGSodmLQXkD5K0hZw55xL3r4d5QasGMJBAlA6J
         +AH6RZMJ3yShaOcD3/9PZAX35+iFfTECF1zcco9e8SOzAxxk6J65lLPNOdcjR9Sjuw9u
         E5pNysXlBo+VInfaSjW7+H5hMOcIk6/dX9ubD5iORZIMulSLnUoDk+ZgZ1tUeZ1h9cwd
         BtLg==
X-Gm-Message-State: AOAM532bDUiCGmcAcs/bftjWI7hikwBobRUi5yaNecv11ComlDeCvq0q
        H5B1q5mufR6jXfse7AZB14P1uA==
X-Google-Smtp-Source: ABdhPJyJ6oDU73XCxB3tcKhbB2wd+k8K27VwNAKkjtzm8Jer9V8/Rt7fN8o46ChfDM0kd+lShSU6VA==
X-Received: by 2002:a19:ed16:: with SMTP id y22mr668637lfy.66.1603452918708;
        Fri, 23 Oct 2020 04:35:18 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id r19sm111450lfm.301.2020.10.23.04.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 04:35:17 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id C4899102F98; Fri, 23 Oct 2020 14:35:17 +0300 (+03)
Date:   Fri, 23 Oct 2020 14:35:17 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFCv2 00/16] KVM protected memory extension
Message-ID: <20201023113517.j543e77hmqenjvgw@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <87ft6949x8.fsf@vitty.brq.redhat.com>
 <20201020134924.2i4z4kp6bkiheqws@box>
 <87eelr4ox3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87eelr4ox3.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 04:46:48PM +0200, Vitaly Kuznetsov wrote:
> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
> 
> > On Tue, Oct 20, 2020 at 09:46:11AM +0200, Vitaly Kuznetsov wrote:
> >> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
> >> 
> >> > == Background / Problem ==
> >> >
> >> > There are a number of hardware features (MKTME, SEV) which protect guest
> >> > memory from some unauthorized host access. The patchset proposes a purely
> >> > software feature that mitigates some of the same host-side read-only
> >> > attacks.
> >> >
> >> >
> >> > == What does this set mitigate? ==
> >> >
> >> >  - Host kernel ”accidental” access to guest data (think speculation)
> >> >
> >> >  - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
> >> >
> >> >  - Host userspace access to guest data (compromised qemu)
> >> >
> >> >  - Guest privilege escalation via compromised QEMU device emulation
> >> >
> >> > == What does this set NOT mitigate? ==
> >> >
> >> >  - Full host kernel compromise.  Kernel will just map the pages again.
> >> >
> >> >  - Hardware attacks
> >> >
> >> >
> >> > The second RFC revision addresses /most/ of the feedback.
> >> >
> >> > I still didn't found a good solution to reboot and kexec. Unprotect all
> >> > the memory on such operations defeat the goal of the feature. Clearing up
> >> > most of the memory before unprotecting what is required for reboot (or
> >> > kexec) is tedious and error-prone.
> >> > Maybe we should just declare them unsupported?
> >> 
> >> Making reboot unsupported is a hard sell. Could you please elaborate on
> >> why you think that "unprotect all" hypercall (or rather a single
> >> hypercall supporting both protecting/unprotecting) defeats the purpose
> >> of the feature?
> >
> > If guest has some data that it prefers not to leak to the host and use the
> > feature for the purpose, share all the memory to get through reboot is a
> > very weak point.
> >
> 
> My point that if it knows that there's something sensitive in its
> memory it should clean it up even today without your feature before
> rebooting to an unknown target.

It's unrealistic to expect everybody to do the right thing.

> >> clean up *all* its memory upon reboot, however:
> >> - It may only clean up the most sensitive parts. This should probably be
> >> done even without this new feature and even on bare metal (think about
> >> next boot target being malicious).
> >> - The attack window shrinks significantly. "Speculative" bugs require
> >> time to exploit and it will only remain open until it boots up again
> >> (few seconds).
> >
> > Maybe it would be cleaner to handle reboot in userspace? If we got the VM
> > rebooted, just reconstruct it from scratch as if it would be new boot.
> 
> We are definitely not trying to protect against malicious KVM so maybe
> we can do the cleanup there (when protection was enabled) so we can
> unprotect everything without risk of a leak?

Do you have any particular codepath in mind? I didn't find anything
suitable so far.

-- 
 Kirill A. Shutemov
