Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0F43B1CDE
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 16:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFWOxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 10:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWOw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 10:52:59 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55059C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 07:50:41 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id s14so1229187pfg.0
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 07:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B6xy+P4LVZ8ouXpvquxMkTV0ybbyNpWgSEbmXO80cWc=;
        b=sPiDqD7KtpRqVbkfjKi/s1koOVTNNfoE70fuvxFKXX5liM9MIF2f1G9qv2pXBoOrB7
         uE5N5s8LNU13c4KWdeD/X7DC2ZMXQeckoX0ayH5GbOTxmz2H48l2eMxjHA6i3dH82v1e
         l52OM4KXoxxaIHyLQdhz4ibxldhl6il9OZ81Wde44ob6c+HRv66Y5VF+l4wqqW9OK/bp
         cuK9trMNbWir3heZ8sBT4Z7VpvmJSEOS1a297/Rx5M32axc+aE5zBbDP6iHRtOuOZT7k
         jFZ/9Kt89wO031pkkexcHnafog0v4wPz2svckv4Wn5ZgjF7OTUygvjaZ1y4h7YvJyuCW
         hh7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B6xy+P4LVZ8ouXpvquxMkTV0ybbyNpWgSEbmXO80cWc=;
        b=BjlG2RVj3enZp8y4FefLIzXBgfz+kls69qTjSqLlCYWUP5Rz3Ia5cxGKVtyTNhLJ0R
         KoZI4hfICZY5xduStO+4el+0sEkuGjZB6aJU94mzjvCQsjVDgumBJq1dlhk1hZxSo4/+
         KtNRlD4Hm1E79XfEq0Vo3h7zV8T6pP+8i0a8c56VPfQ245yww5vp+80nRia8hmqZOniE
         kapqDd8xF2SNRk2lYrtbtE4MZOHZXFtfwX6h8p1LNVKoHg4NbyJWiZKha6sxZYT/jT9y
         Y1oY+nTMelWjdVrdlsdvOqUKpX+z+YwXfQcxR81w5LJjHcZV/3fgSEMYmjFESlBQCBLH
         BzOw==
X-Gm-Message-State: AOAM530S16JAr4NoT/yNTuVroOF6aVb9MvkhbDKjrlmDJz9RzpXe0TrV
        3eBLEdfmcmf1UgIavj4YOkhoJw==
X-Google-Smtp-Source: ABdhPJwlCsnQ3HJUbRW0iOFd5eh5pl/ForJhk2KhDOF9UWAWih4xsOEeaD8m0InKaDy1sE1ERL003Q==
X-Received: by 2002:a63:ed12:: with SMTP id d18mr4205416pgi.12.1624459840567;
        Wed, 23 Jun 2021 07:50:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w123sm198370pfb.109.2021.06.23.07.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 07:50:39 -0700 (PDT)
Date:   Wed, 23 Jun 2021 14:50:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 03/54] KVM: x86: Properly reset MMU context at vCPU
 RESET/INIT
Message-ID: <YNNKPADJamqhmDpV@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-4-seanjc@google.com>
 <3c3f9251-cab4-70ee-6e38-85fe8e6579f7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c3f9251-cab4-70ee-6e38-85fe8e6579f7@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:56, Sean Christopherson wrote:
> > +	/*
> > +	 * Reset the MMU context if paging was enabled prior to INIT (which is
> > +	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
> > +	 * standard CR0/CR4/EFER modification paths, only CR0.PG needs to be
> > +	 * checked because it is unconditionally cleared on INIT and all other
> > +	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
> > +	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
> > +	 */
> > +	if (old_cr0 & X86_CR0_PG)
> > +		kvm_mmu_reset_context(vcpu);
> 
> Hmm, I'll answer myself, is it because of the plan to add a vCPU reset
> ioctl?

Heh, no, I'm not thinking that far ahead at the moment.

Using "if (init_event)" also resets the MMU when paging was disabled prior to
INIT, which is unnecessary.  "if (init_event && (old_cr0 & X86_CR0_PG))" would
obviously work, but I guess I was feeling clever.

As for why I don't want to unnecessarily reset the MMU, my preference for the MMU
role/context logic is to be as precise as possible to help document "why".  Doing
a MMU reset on any INIT obviously won't break anything, but it doesn't highlight
that the true motivation is CR0.PG being cleared, not simply that INIT occurred.
I.e. the MMU context is a KVM construct, there is no architectural model that
we're trying to follow.
