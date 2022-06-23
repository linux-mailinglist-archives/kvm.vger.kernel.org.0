Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B326558956
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 21:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiFWTlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 15:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiFWTlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 15:41:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21109CDB
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 12:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656012765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cEzj9L77P8v8qoCIIdtw9E/V13id72lLb1/JCaB9X5o=;
        b=MvTjiEQMO1Mz+axksvMdFg69n3A+R4ZgCSoGMqeI3JR5dnYz3L+i6Bnj8K4OVcehJWkOPv
        epyYnXzn4InCrrdLVVraG4LHBbVkq5wTQyh0MPWfli0D4mlCxznv0uYmaxChRIo5GWob+9
        ee11uLvo9VsJ4f14914ppSiK75ZQMwY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-droLyTf4NJivcTnciSZ5mg-1; Thu, 23 Jun 2022 15:32:44 -0400
X-MC-Unique: droLyTf4NJivcTnciSZ5mg-1
Received: by mail-io1-f69.google.com with SMTP id d11-20020a6bb40b000000b006727828a19fso196842iof.15
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 12:32:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cEzj9L77P8v8qoCIIdtw9E/V13id72lLb1/JCaB9X5o=;
        b=ZBhUgTMzvg/jo0TvRT7OhkqD2nxt27wqdkQgHqaMLL2BZ0Y0O4sLrbnzlyZn6P8IDp
         n1mPrFuYIUZwEeF04+bcCkOxAUDRNS+0j267DXIttUZ7Yz4qQzR2hP6dAiuItdKfWj8T
         SKLTI2VP7lmFLuXqfVAxuukIAjjdVIt+/7nB5sodhRD5y8WMXRnloBOgugKTi3HnSQla
         FrA5+jqbReVZ/G6ePdhuRZarzwAzEXXuwqcnTW6C6djq6zTgXkASCWiGLP9BLZA1irvj
         3LgzccmWlbJmGvO680ncOK/iZtnKPPzmBOuFAyX5NLw1aMnwM4wzhgPQkv1gKIuYh6Al
         HuEw==
X-Gm-Message-State: AJIora+0JrqAxJAXdvIi1drBgfFUC4KVuRz8u8XwxfwVFKzs3sIBAV+s
        tSo12Km076e3nCSWetaJDRecxDuz8EWWn6Xm0GpT6MrMOUT1xizmDY23/WWThbVHevbqx+1cVAv
        NYeWquDp0wk2U
X-Received: by 2002:a05:6638:1301:b0:331:f2f0:a17e with SMTP id r1-20020a056638130100b00331f2f0a17emr6002364jad.141.1656012762857;
        Thu, 23 Jun 2022 12:32:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s65EoE7PAH6kAoTAtGR4qw5bac4MpVebXW5cXpFV1QXeylyQ+L/Y/fNAavK3gdSfdi9iPExw==
X-Received: by 2002:a05:6638:1301:b0:331:f2f0:a17e with SMTP id r1-20020a056638130100b00331f2f0a17emr6002319jad.141.1656012761972;
        Thu, 23 Jun 2022 12:32:41 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id z7-20020a923207000000b002d1d3b1abbesm173633ile.80.2022.06.23.12.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:32:41 -0700 (PDT)
Date:   Thu, 23 Jun 2022 15:32:39 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/4] kvm: Add new pfn error KVM_PFN_ERR_INTR
Message-ID: <YrS/13dBmSIpvd3C@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-4-peterx@redhat.com>
 <YrR5U1mHP9fYQ1k9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrR5U1mHP9fYQ1k9@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 02:31:47PM +0000, Sean Christopherson wrote:
> On Wed, Jun 22, 2022, Peter Xu wrote:
> > Add one new PFN error type to show when we cannot finish fetching the PFN
> > due to interruptions.  For example, by receiving a generic signal.
> > 
> > This prepares KVM to be able to respond to SIGUSR1 (for QEMU that's the
> > SIGIPI) even during e.g. handling an userfaultfd page fault.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  include/linux/kvm_host.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index b646b6fcaec6..4f84a442f67f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -96,6 +96,7 @@
> >  #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
> >  #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
> >  #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
> > +#define KVM_PFN_ERR_INTR	(KVM_PFN_ERR_MASK + 3)
> >  
> >  /*
> >   * error pfns indicate that the gfn is in slot but faild to
> > @@ -106,6 +107,16 @@ static inline bool is_error_pfn(kvm_pfn_t pfn)
> >  	return !!(pfn & KVM_PFN_ERR_MASK);
> >  }
> >  
> > +/*
> > + * When KVM_PFN_ERR_INTR is returned, it means we're interrupted during
> > + * fetching the PFN (e.g. a signal might have arrived), so we may want to
> > + * retry at some later point and kick the userspace to handle the signal.
> > + */
> > +static inline bool is_intr_pfn(kvm_pfn_t pfn)
> > +{
> > +	return pfn == KVM_PFN_ERR_INTR;
> 
> What about is_sigpending_pfn() and KVM_PFN_ERR_SIGPENDING?  "intr" is too close to
> a real thing KVM will encounter, and I think knowing that KVM is effectively
> responding to a pending signal is the most important detail for KVM developers
> encountering this code for this first time.  E.g. from KVM_PFN_ERR_INTR alone, one
> might think that any interrupt during GUP will trigger this.

Sounds good; INTR could be too general for KVM indeed.  Thanks,

-- 
Peter Xu

