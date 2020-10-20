Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E1293D9F
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 15:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407682AbgJTNt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 09:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407628AbgJTNt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 09:49:28 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB751C061755
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 06:49:27 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id h6so2190803lfj.3
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 06:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1o8TpeHhno8OE2SrDdQUqRsdXAVOC0TzkDg0pRysRCg=;
        b=cicVnczstWRFH9gw+EuYx/lkIIBZzIw/xFGQDmuS3kVvj7vDkCCzApdH1mGBpMoiA9
         UtpBzyMmwiraaOs2MZMRvwTopaDFxaacSqLiI/IFdi8hKKrlZORdjZIJsLS3cLypFks/
         Bda/wOENIgPWwOMRaDoliBIRfRwHPiY6madPv88jbUecOdIdC863Zw3wYV4k28/eBqGi
         W2EDYSVlOfa6oSB3jXwakuWfGlTrNxPtkIc3sHP4hip+5nDyO4AZhVF1W7eZd1S7ISnM
         q/XrxAC2qb0wuhsp5epuANvG0/N4WWTpFeq7y8QxSVLZcING1Hvt56ZqLKl9e4GR5Zim
         1olw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1o8TpeHhno8OE2SrDdQUqRsdXAVOC0TzkDg0pRysRCg=;
        b=r0pJePbee59rNnPjStIugHLJ9p4diqb9kcDt+fMFmLfdHkIeCHQwWGgHPwkOEBuMmz
         WFhxj+FWmxx1kHRotCDqmmu/F3C+1/uyWSmsI0I3RD9oOgVRxcuwRsE0luP+r3huKS3N
         S9AY+vQPzkfMxDqDDoZ4VZvmivJmnJ+l6JUNrzgCXOy/FYK64sAOA/G2lLanl5JfcfgB
         FRTWPjzFUvAOEE/cq1zhGcIQ90rRefsL/E3IFcHqRgj9ACzS7X6eH2aJw8DR0q/rVE93
         DNikKktEoKKowF3ZqGsq3kFnQgwl8SZD3PUxQGb7rTUo5j7X7tP0NKmD79tvIvrxkg7p
         bUKA==
X-Gm-Message-State: AOAM531mS4UtiwlMbTHTYaSsXRRFSSqQa3fqpdc0ML+GPom4ryMWwROT
        nt5j82bTLoI6y0wp8trX8TWcSQ==
X-Google-Smtp-Source: ABdhPJwzV88aVC3wAh1fZRh2Qt1Fuvww50QbPS9U7q8Lm6OYo/M98+w8nswpqWagGg+ahtm5dpfxOw==
X-Received: by 2002:ac2:5a05:: with SMTP id q5mr976885lfn.592.1603201766368;
        Tue, 20 Oct 2020 06:49:26 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id o17sm319166lfb.55.2020.10.20.06.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 06:49:25 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 2039A102328; Tue, 20 Oct 2020 16:49:24 +0300 (+03)
Date:   Tue, 20 Oct 2020 16:49:24 +0300
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
Message-ID: <20201020134924.2i4z4kp6bkiheqws@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <87ft6949x8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ft6949x8.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 09:46:11AM +0200, Vitaly Kuznetsov wrote:
> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
> 
> > == Background / Problem ==
> >
> > There are a number of hardware features (MKTME, SEV) which protect guest
> > memory from some unauthorized host access. The patchset proposes a purely
> > software feature that mitigates some of the same host-side read-only
> > attacks.
> >
> >
> > == What does this set mitigate? ==
> >
> >  - Host kernel ”accidental” access to guest data (think speculation)
> >
> >  - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
> >
> >  - Host userspace access to guest data (compromised qemu)
> >
> >  - Guest privilege escalation via compromised QEMU device emulation
> >
> > == What does this set NOT mitigate? ==
> >
> >  - Full host kernel compromise.  Kernel will just map the pages again.
> >
> >  - Hardware attacks
> >
> >
> > The second RFC revision addresses /most/ of the feedback.
> >
> > I still didn't found a good solution to reboot and kexec. Unprotect all
> > the memory on such operations defeat the goal of the feature. Clearing up
> > most of the memory before unprotecting what is required for reboot (or
> > kexec) is tedious and error-prone.
> > Maybe we should just declare them unsupported?
> 
> Making reboot unsupported is a hard sell. Could you please elaborate on
> why you think that "unprotect all" hypercall (or rather a single
> hypercall supporting both protecting/unprotecting) defeats the purpose
> of the feature?

If guest has some data that it prefers not to leak to the host and use the
feature for the purpose, share all the memory to get through reboot is a
very weak point.

> 
> clean up *all* its memory upon reboot, however:
> - It may only clean up the most sensitive parts. This should probably be
> done even without this new feature and even on bare metal (think about
> next boot target being malicious).
> - The attack window shrinks significantly. "Speculative" bugs require
> time to exploit and it will only remain open until it boots up again
> (few seconds).

Maybe it would be cleaner to handle reboot in userspace? If we got the VM
rebooted, just reconstruct it from scratch as if it would be new boot.

-- 
 Kirill A. Shutemov
