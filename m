Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399DC344FFA
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 20:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhCVThj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 15:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbhCVThR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 15:37:17 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B72C061574
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 12:37:17 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k24so9349458pgl.6
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 12:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qvddc12ssbuhTzdYauyJcg7qK3PaV6O5XEgKX+12530=;
        b=ALbEa1nQdl0T7mSaklA3MDmV8msFOB3KD/zEVk7QGcnUGXv+lGMnn6dt/R2lkjld8l
         jYA6oHq/YOcwCiQw3FZCTOQ4+KDR9bXW3mNo5snf0Y58t4HZedo9Cia2GHGwevB4R5vt
         EfzDsI0HyIZsDz2rqgZsFUVzSQl6ZGqOyvshdbP4WDTVRYV2jAHoq+OoH1rxJy3qYeVm
         LDZvvqzGaspDhwwjTpFl8E8toEXfkyMM18ixHMMLx2VXRIkFkFsbZf4pFRAexx48y1pb
         siYXO/lcOhJ3XaRj1CM8EYYTyejfdGIexPySy1NWn+E4HNudVHWGlpik1uFySRBY+4P/
         x5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qvddc12ssbuhTzdYauyJcg7qK3PaV6O5XEgKX+12530=;
        b=Su1lPt9z6hwrATlGsR+U056X1afMpY0dVNHdd2cnqOWQmAFn1h1aC91a0E+13QkoT+
         0o4/P4WKXJizDShvP5AdV2bXCxkP8CyJWFV7q+b7kMXl3oECZXbMWicNUkLGGaX6GfW7
         OkHgHEuOF9IRX6AEvkH++BP7hnpVtMgZpycyVqFkz/E8hpUN8qj3rtxSQ+fsi3/SXRoq
         dn9Hutg9DcAVj/jH1hP7pv6vTZzWC8+C16m/D46eZrvv3NtCWRxJrH4AlFpO6kN8RQxE
         G8YUYHrzDKfAT+hN0S7Vnl2d9x4b48PuB///zZ5SFgBWNH5wVI7xR60nVZTYK91haglk
         LcpA==
X-Gm-Message-State: AOAM531EFe3Ve5dM1EYu28/U+PTYj9LZ6u0IEcAafDVdzJdzMBS6Ry/t
        xkk4ZuhgOWcInm7RJDbANbj/yw==
X-Google-Smtp-Source: ABdhPJxy1YxPpf5EB/bl0nujXGLosHLNcbYSrcDYEbDjvSK7q0814Q4smLTb1Tx4qbVMKv20S2dREw==
X-Received: by 2002:a62:1913:0:b029:20f:eadf:28c1 with SMTP id 19-20020a6219130000b029020feadf28c1mr1037239pfz.58.1616441836579;
        Mon, 22 Mar 2021 12:37:16 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:f8cd:ad3d:e69f:e006])
        by smtp.gmail.com with ESMTPSA id x7sm227732pjr.7.2021.03.22.12.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 12:37:15 -0700 (PDT)
Date:   Mon, 22 Mar 2021 12:37:02 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YFjx3vixDURClgcb@google.com>
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic>
 <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322191540.GH6481@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021, Borislav Petkov wrote:
> On Mon, Mar 22, 2021 at 11:56:37AM -0700, Sean Christopherson wrote:
> > Not necessarily.  This can only trigger in the host, and thus require a host
> > reboot, if the host is also running enclaves.  If the CSP is not running
> > enclaves, or is running its enclaves in a separate VM, then this path cannot be
> > reached.
> 
> That's what I meant. Rebooting guests is a lot easier, ofc.
> 
> Or are you saying, this can trigger *only* when they're running enclaves
> on the *host* too?

Yes.  Note, it's still true if you strike out the "too", KVM support is completely
orthogonal to this code.  The purpose of this patch is to separate out the EREMOVE
path used for host enclaves (/dev/sgx_enclave), because EPC virtualization for
KVM will have non-buggy scenarios where EREMOVE can fail.  But the virt EPC code
is designed to handle that gracefully.

> > EREMOVE can only fail if there's a kernel or hardware bug (or a VMM bug if
> > running as a guest). 
> 
> We get those on a daily basis.
> 
> > IME, nearly every kernel/KVM bug that I introduced that led to EREMOVE
> > failure was also quite fatal to SGX, i.e. this is just the canary in
> > the coal mine.
> >
> > It's certainly possible to add more sophisticated error handling, e.g. through
> > the pages onto a list and periodically try to recover them.  But, since the vast
> > majority of bugs that cause EREMOVE failure are fatal to SGX, implementing
> > sophisticated handling is quite low on the list of priorities.
> > 
> > Dave wanted the "page leaked" error message so that it's abundantly clear that
> > the kernel is leaking pages on EREMOVE failure and that the WARN isn't "benign".
> 
> So this sounds to me like this should BUG too eventually.
> 
> Or is this one of those "this should never happen" things so no one
> should worry?

Hmm.  I don't think it warrants BUG.  At worst, leaking EPC pages is fatal only
to SGX.  If the underlying bug caused other fallout, e.g. didn't release a lock,
then obviously that could be fatal to the kernel.  But I don't think there's
ever a case where SGX being unusuable would prevent the kernel from functioning.
 
> Whatever it is, if an admin sees this message in dmesg and doesn't get a
> lengthy explanation what she/he is supposed to do, I don't think she/he
> will be as relaxed.
> 
> Hell, people open bugs for correctable ECCs and are asking whether they
> need to replace their hardware.

LOL.

> So let's play this out: put yourself in an admin's shoes and tell me how
> should an admin react when she/he sees that?
> 
> Should the kernel probably also say: "Don't worry, you have enough
> memory and what's a 4K, who cares? You'll reboot eventually."
 
> Or should the kernel say "You need to reboot ASAP."
> 
> And so on...
> 
> So what is the scenario here and what kind of reaction is that message
> supposed to cause, recovery action, blabla, the whole spiel?

Probably something in between.  Odds are good SGX will eventually become
unusuable, e.g. either kernel SGX support is completely hosted, or it will soon
leak the majority of EPC pages.  Something like this?

  "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become unusuable.  Reboot recommended to continue using SGX."
