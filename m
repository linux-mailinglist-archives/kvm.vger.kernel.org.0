Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B5F37CBD1
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbhELQiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 12:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbhELQMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 12:12:34 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6909BC034611
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 08:51:15 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id i190so18768022pfc.12
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 08:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ml4FlirfAM0Le7fdpn8CEXufxztA/hSk61DRpU9Z7dU=;
        b=h9gcbIMmQlnhLY9eH9K/D52LdTHz0QSead5AUJGn8prv4jJW8YLJk0yzikEktL2678
         cV+V/+Ne2I1obYyvZzwTBXSQrcrPhHBTzjOzCOnWm1nTV0yHdXfUfg/Xt4y9n+0cOvAV
         cpVCAo1lyNLRqj/yuyta82edBvWKROo4XQHKwzyhy8FtyZ/7eBJb+ccoZSKzX8NgN5r7
         FPgqGqqeJVU2s8xiqo/l5GMi8xDMOoHVbkOgKGkl4xwEetf1UfYX9gCs73d250Fi7IKI
         iZzuO+0I34INxObQA5bVLhxYs+1k69fdvDMa9yVl6EUU19jtwrqXy7zJkKNdKJQ+H1T/
         1KVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ml4FlirfAM0Le7fdpn8CEXufxztA/hSk61DRpU9Z7dU=;
        b=hn1mDPkO8777aBpLOda3VR0BfxTF+uQigbP7rIKRtoKoCF0sVvTESr2/YC1XmHf/Lv
         Z83gaYebyGXFwp+37TrYggKEOCuDpalU5eX0v8h8XvwDzVLBeyTlTnJjNdSVa7kJt27B
         PCRPUJejT/sf8DaEXgkaM8oLk+B62UgepzpWzio6bZEeIDp26GNdGqw/2o7+L0DpZVVA
         SLI67Pp0x78jAy6QV2zG7MQZe/Si6hXCzwtVkvEXQP1DM6FFenQ4lzJj6Gkgfdg4YL7k
         XxbYE+ObTVJK0EtbQisxSQ+nX4M5Vpq2fUIKBdkUAiZQEVd8o725RuXAY7P0jYXHvwvj
         FC7A==
X-Gm-Message-State: AOAM530XZ5EXyxdSR8PJgdg4ze1WKmZq4hTACurnCD0Ws/aUzrnVM1Nh
        fT/2WEYMvQhuNjMIhqIqLg1WXA==
X-Google-Smtp-Source: ABdhPJzj1YpYhdkaQh59hJxLv43j3+jK88a9dOARyY72/6HKjVRUp+Bs9CNBqVhu9XIAAXmAy07jGw==
X-Received: by 2002:a65:550e:: with SMTP id f14mr8841530pgr.160.1620834674732;
        Wed, 12 May 2021 08:51:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h24sm218439pfn.180.2021.05.12.08.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 08:51:14 -0700 (PDT)
Date:   Wed, 12 May 2021 15:51:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <YJv5bjd0xThIahaa@google.com>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJvU+RAvetAPT2XY@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Borislav Petkov wrote:
> On Fri, Apr 23, 2021 at 03:58:43PM +0000, Ashish Kalra wrote:
> > +static inline void notify_page_enc_status_changed(unsigned long pfn,
> > +						  int npages, bool enc)
> > +{
> > +	PVOP_VCALL3(mmu.notify_page_enc_status_changed, pfn, npages, enc);
> > +}
> 
> Now the question is whether something like that is needed for TDX, and,
> if so, could it be shared by both.

Yes, TDX needs this same hook, but "can't" reuse the hypercall verbatime.  Ditto
for SEV-SNP.  I wanted to squish everything into a single common hypercall, but
that didn't pan out.

The problem is that both TDX and SNP define their own versions of this so that
any guest kernel that complies with the TDX|SNP specification will run cleanly
on a hypervisor that also complies with the spec.  This KVM-specific hook doesn't
meet those requires because non-Linux guest support will be sketchy at best, and
non-KVM hypervisor support will be non-existent.

The best we can do, short of refusing to support TDX or SNP, is to make this
KVM-specific hypercall compatible with TDX and SNP so that the bulk of the
control logic is identical.  The mechanics of actually invoking the hypercall
will differ, but if done right, everything else should be reusable without
modification.

I had an in-depth analysis of this, but it was all off-list.  Pasted below. 

  TDX uses GPRs to communicate with the host, so it can tunnel "legacy" hypercalls
  from time zero.  SNP could technically do the same (with a revised GHCB spec),
  but it'd be butt ugly.  And of course trying to go that route for either TDX or
  SNP would run into the problem of having to coordinate the ABI for the "legacy"
  hypercall across all guests and hosts.  So yeah, trying to remove any of the
  three (KVM vs. SNP vs. TDX) interfaces is sadly just wishful thinking.

  That being said, I do think we can reuse the KVM specific hypercall for TDX and
  SNP.  Both will still need a {TDX,SNP}-specific GCH{I,B} protocol so that cross-
  vendor compatibility is guaranteed, but that shouldn't preclude a guest that is
  KVM enlightened from switching to the KVM specific hypercall once it can do so.
  More thoughts later on.

  > I guess a common structure could be used along the lines of what is in the
  > GHCB spec today, but that seems like overkill for SEV/SEV-ES, which will
  > only ever really do a single page range at a time (through
  > set_memory_encrypted() and set_memory_decrypted()). The reason for the
  > expanded form for SEV-SNP is that the OS can (proactively) adjust multiple
  > page ranges in advance. Will TDX need to do something similar?

  Yes, TDX needs the exact same thing.  All three (SEV, SNP, and TDX) have more or
  less the exact same hook in the guest (Linux, obviously) kernel.

  > If so, the only real common piece in KVM is a function to track what pages
  > are shared vs private, which would only require a simple interface.

  It's not just KVM, it's also the relevant code in the guest kernel(s) and other
  hypervisors.  And the MMU side of KVM will likely be able to share code, e.g. to
  act on the page size hint.

  > So for SEV/SEV-ES, a simpler hypercall interface to specify a single page
  > range is really all that is needed, but it must be common across
  > hypervisors. I think that was one Sean's points originally, we don't want
  > one hypercall for KVM, one for Hyper-V, one for VMware, one for Xen, etc.

  For the KVM defined interface (required for SEV/SEV-ES), I think it makes sense
  to make it a superset of the SNP and TDX protocols so that it _can_ be used in
  lieu of the SNP/TDX specific protocol.  I don't know for sure whether or not
  that will actually yield better code and/or performance, but it costs us almost
  nothing and at least gives us the option of further optimizing the Linux+KVM
  combination.

  It probably shouldn't be a strict superset, as in practice I don't think SNP
  approach of having individual entries when batching multiple pages will yield
  the best performance.  E.g. the vast majority (maybe all?) of conversions for a
  Linux guest will be physically contiguous and will have the same preferred page
  size, at which point there will be less overhead if the guest specifies a
  massive range as opposed to having to santize and fill a large buffer.

  TL;DR: I think the KVM hypercall should be something like this, so that it can
  be used for SNP and TDX, and possibly for other purposes, e.g. for paravirt
  performance enhancements or something.

    8. KVM_HC_MAP_GPA_RANGE
    -----------------------
    :Architecture: x86
    :Status: active
    :Purpose: Request KVM to map a GPA range with the specified attributes.

    a0: the guest physical address of the start page
    a1: the number of (4kb) pages (must be contiguous in GPA space)
    a2: attributes

  where 'attributes' could be something like:

    bits  3:0 - preferred page size encoding 0 = 4kb, 1 = 2mb, 2 = 1gb, etc...
    bit     4 - plaintext = 0, encrypted = 1
    bits 63:5 - reserved (must be zero)

