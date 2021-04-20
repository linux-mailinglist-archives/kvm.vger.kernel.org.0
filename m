Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F03A365F8F
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhDTSlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhDTSlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 14:41:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6D5C06138A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:40:45 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f6-20020a17090a6546b029015088cf4a1eso5101640pjs.2
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4nTYHF9QS/Q9WoCJw/u+L5pBMc3V8p+wlC3603sKOj4=;
        b=hvLe2o7sT3oWl/fEbgbgGtEJPUgJGw/6XpUZm+ms8RNBS7S+seOYlOjE+B+8CQlJVG
         RNiTK9Y5SUuX0tiLOxru3FSd9RyW1tIrC3HBtNWp5T+Ncr9OsWKQkPAVrNcsEVxT6+tt
         9EP7ewrMu69ERqjGZwqF+zRQ6vB/4MhO9oLIxKmAYu8hQJS4q2JuOPh9fJ+nazj4bcep
         5MYz51YtM/Lo/VycEDI1qK7H3w/pdRUhJo2XK0dkP02mYFu5bpj0S+8tzx7cIjbyps1I
         TD8jkRy6CjYu/9VLfonRj+2xk7qpk1QMte5LxwmmWYrf34g2COCG26A7vQL7FyYq0FQh
         RO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4nTYHF9QS/Q9WoCJw/u+L5pBMc3V8p+wlC3603sKOj4=;
        b=s+0dPvEnoBJ5wz9oB2qJk8upoU8E1PwsmP74Zg7q0dw6mn6YJzwUkuWZKj3yNiIYFK
         voUcdC6Ylmj0+in/syDj98frt955pYevmiOfyDl7H8GlchVacmTijYI+U0d/MC94P+UE
         +uxyLJBEZQUHQH08EbgUlqdBDNhlWDArw8XfcPCdOQL05eUmWgtL05EmMb5phJEV9WRF
         sURihZfCJrkXF06FY6Z4zGEdWo9NZf5mUzkzAZHlwDlVcfjoUb2AJfu7DIGQPjezAQTR
         nlsBEhoRQQUqdIkwMUDXfiJWxNprYivQ//x6qmnzTgaItfZMzCNBfYYDRFeLBl0zUUbQ
         3pNg==
X-Gm-Message-State: AOAM532eGO+707Q25HLgb6YCC7QuEIbQMTeJ2TDjsybZ993AeXN5I56K
        xHN7UFMZh7uS3n21fe0gwq4m6Q==
X-Google-Smtp-Source: ABdhPJwLtV3eYPCTSS2TmLWh58OjIvh4AFl/89SXbnGqa8kyVZbG+76tU+3+IAk0u8RLkP+3xKxB1w==
X-Received: by 2002:a17:90a:b292:: with SMTP id c18mr6745373pjr.179.1618944045026;
        Tue, 20 Apr 2021 11:40:45 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id cv12sm2478514pjb.35.2021.04.20.11.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:40:44 -0700 (PDT)
Date:   Tue, 20 Apr 2021 18:40:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, srutherford@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        venu.busireddy@oracle.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
Message-ID: <YH8gKcxE+dfulftQ@google.com>
References: <20210420112006.741541-1-pbonzini@redhat.com>
 <YH8P26OibEfxvJAu@google.com>
 <20210420181124.GA12798@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420181124.GA12798@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Ashish Kalra wrote:
> On Tue, Apr 20, 2021 at 05:31:07PM +0000, Sean Christopherson wrote:
> > On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> > > +	case KVM_HC_PAGE_ENC_STATUS: {
> > > +		u64 gpa = a0, npages = a1, enc = a2;
> > > +
> > > +		ret = -KVM_ENOSYS;
> > > +		if (!vcpu->kvm->arch.hypercall_exit_enabled)
> > 
> > I don't follow, why does the hypercall need to be gated by a capability?  What
> > would break if this were changed to?
> > 
> > 		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS))
> > 
> 
> But, the above indicates host support for page_enc_status_hc, so we want
> to ensure that host supports and has enabled support for the hypercall
> exit, i.e., hypercall has been enabled.

I still don't see how parroting back KVM_GET_SUPPORTED_CPUID, i.e. "unintentionally"
setting KVM_FEATURE_HC_PAGE_ENC_STATUS, would break anything.  Sure, the guest
does unnecessary hypercalls, but they're eaten by KVM.  On the flip side, gating
the hypercall on the capability, and especially only the capability, creates
weird scenarios where the guest can observe KVM_FEATURE_HC_PAGE_ENC_STATUS=1
but fail the hypercall.  Those would be fairly clearcut VMM bugs, but at the
same time KVM is essentially going out of its way to manufacture the problem.
