Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130A53EA8A6
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 18:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhHLQoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 12:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhHLQoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 12:44:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5F5C0613D9
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:43:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so11623418pjl.4
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z693XsiBKLrJvSZ/YAAMgAz4mbAtqabwjx08Gr/DpaA=;
        b=bsXEPviGSDTJ7TDuPHVI19R5NuLoJ2kf8Gaw7EKQDdJmou0qLOnQG5dWGm37aEdqD9
         96Nzf+MCAlpC3PxOTU9UU/Kst8rqgPBcfjl8lP38f9gEGT/1+mrCftDd1ehXZgWxRqmY
         7dukLUx9IxpTI/84upP+ww7oQYY7zUBZqfb3Pye+i9VIPkgbetLMq6S1l0zFqo4+D8xZ
         TM+VIqiWUQn7OkMZ9RTAKua2XPdr5atIZqyT8D+Cer3lLWjBqy0dj9SsHmP4X5YwpZj3
         R7NTJAdLT/U2ZM6L1YaMAbMqOmzn4f/20r5XePvIzKWL/j91wc1Xsi7wg3qDLioYUqRh
         pGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z693XsiBKLrJvSZ/YAAMgAz4mbAtqabwjx08Gr/DpaA=;
        b=eMupY6PWswbyHzJDHM4kEzHi7s3Q34X7B80GUNwa70dnmLIumyNVGb8+Ojlyb3Asng
         umfYACFkf7cIeyBqk0ui2KlbTpmtnuNLkYs5B0YMoqdvp5O7elWkIDc5r+5GxztEPfXc
         MRIdpdvUTzNbKy0dGxY1FdcWP8b7RsVEsYXB1By0V7S54Of1nQ8mmDAEwQoLiied4EJ/
         o/tWt0XvOAuCfpJ3aaniyE4pQRNIe5cZKXVQfKj5yTbkFux7iUtuK5YVP1Rl++6ZnLcS
         FDCU3Lfm1iT8Q68YTLQmAVZibjw9V8nocujf48jYTHCXlxeVmr5hY29p4MRMqmJ2vVe7
         JrLQ==
X-Gm-Message-State: AOAM5328fwIWNXgyiO81wUNBcn3sMT5aVdOs2Id32ADKOK3R1O7/C6iq
        4+7PejT6742/+8K8Z0n1aDOKVA==
X-Google-Smtp-Source: ABdhPJwlGCKp/K9xjWsUK3OWafCfD6463Y9XffOe17Y9OHk5HyISbCPM0vw0Mx//+9WqGVF1o8GqOw==
X-Received: by 2002:a63:4a41:: with SMTP id j1mr4493549pgl.227.1628786634700;
        Thu, 12 Aug 2021 09:43:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o22sm3877172pfu.87.2021.08.12.09.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 09:43:54 -0700 (PDT)
Date:   Thu, 12 Aug 2021 16:43:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Don't skip non-leaf SPTEs when zapping
 all SPTEs
Message-ID: <YRVPxCv2RtyXi+XO@google.com>
References: <20210812050717.3176478-1-seanjc@google.com>
 <20210812050717.3176478-2-seanjc@google.com>
 <01b22936-49b0-638e-baf8-269ba93facd8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01b22936-49b0-638e-baf8-269ba93facd8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021, Paolo Bonzini wrote:
> On 12/08/21 07:07, Sean Christopherson wrote:
> > @@ -739,8 +749,16 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >   			  gfn_t start, gfn_t end, bool can_yield, bool flush,
> >   			  bool shared)
> >   {
> > +	bool zap_all = (end == ZAP_ALL_END);
> >   	struct tdp_iter iter;
> > +	/*
> > +	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> > +	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> > +	 * and so KVM will never install a SPTE for such addresses.
> > +	 */
> > +	end = min(end, 1ULL << (shadow_phys_bits - PAGE_SHIFT));
> 
> Then zap_all need not have any magic value.  You can use 0/-1ull, it's
> readable enough.  ZAP_ALL_END is also unnecessary here if you do:
> 
> 	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> 	bool zap_all = (start == 0 && end >= max_gfn_host);

Aha!  Nice.  I was both too clever and yet not clever enough.

> 	end = min(end, max_gfn_host);
> 
> And as a small commit message nit, I would say "don't leak" instead of
> "don't skip", since that's really the effect.

Hrm, yeah, I can see how "skip" doesn't raise alarm bells like it should.
