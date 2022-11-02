Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B3161675B
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiKBQLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiKBQLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:11:12 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5192B19C
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:11:11 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id i3so16798325pfc.11
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xjbiGog+CMLFws9ba0e8gTV0L7Jl5w0vMwDQ7UNnmBw=;
        b=fg5ss+yu7hOd7zMQAayXu1r5V5FRoeiX0Ib8rbO1Hbpnplg28DwPoTzY3KXbp2IM5l
         c8LhKRuFMH0LpjHZqJ/2MO63rmotIEtPBD0D+rrJYFHPwGvPjKFUWsaM0f6Or6MD+PMa
         xWZBW7C28NlVRSBqddoR8LLJS5WgYHillPL2TPvWLB/q/bsrRkhbFv47BZ6Sjtk0FQVM
         enNFn/n81hHrMVGNCRCSpNhDfglnUMmtyta2ATX+wgX831Gh9RjaU/U3AQkd3cynJHeo
         U+5ETSrGJcaCiKGZdkgrI0jt9/jJ9kNO/LscVkh2clSBXP1iXeLU5+XbUTtSax048fuO
         WbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjbiGog+CMLFws9ba0e8gTV0L7Jl5w0vMwDQ7UNnmBw=;
        b=PRcf+16h9vIW4u4/b4SwXX5uorj6bzGatccRubVx9+ALaY1sWsuEo4i3PxmcsaHnwU
         aZO6zt+hIDntDKAcANvGxadrmxta0oZ416Pa4sD8JPBROtT1YqE+aXZkatSodZGa0Kfo
         aKw3LF9gxq7+Cjd5dUou4GEA+mb9J+4m3nqJ5YWqtkLkZ7HX0wYUDRb97PIzGPUt82ga
         VARpwv9K7Pn/P66qv46AatcRjvNSSHl9gh0uWkLo10IIbETyyjZpiPgZTuNpGDK5PtKF
         h4G9aZ1oFBoiG7mF+o2/GPEoVMk9WwFrDP6nlZxsSrGaopn0h1yUVahTHPlIiWz6ax/l
         No8Q==
X-Gm-Message-State: ACrzQf0kbs/+DyCmbgA9+sRD48/A74jnfxMQJUVypVurhDhfUENEEaxZ
        m39J807Ly3HwucuRJnNk3r0MOw==
X-Google-Smtp-Source: AMsMyM40y/EP1XZjLr8u5d95J50ow6Qq/UpZGFYNazWh9EsURT6JqjOG9NRHwf0ExoNxySlBc1J0Zw==
X-Received: by 2002:a63:8b42:0:b0:46f:5bd0:1ae2 with SMTP id j63-20020a638b42000000b0046f5bd01ae2mr21786579pge.422.1667405471018;
        Wed, 02 Nov 2022 09:11:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902710f00b001885041d7b8sm77000pll.293.2022.11.02.09.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:11:10 -0700 (PDT)
Date:   Wed, 2 Nov 2022 16:11:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Peter Xu <peterx@redhat.com>, Gavin Shan <gshan@redhat.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, oliver.upton@linux.dev, james.morse@arm.com,
        shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KWm8wiL3jBryMI@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867d0de4b0.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022, Marc Zyngier wrote:
> On Wed, 02 Nov 2022 14:29:26 +0000, Peter Xu <peterx@redhat.com> wrote:
> > However I don't see anything stops a simple "race" to trigger like below:
> > 
> >           recycle thread                   vcpu thread
> >           --------------                   -----------
> >       if (!dirty_ring_soft_full)                                   <--- not full
> >                                         dirty_ring_push();
> >                                         if (dirty_ring_soft_full)  <--- full due to the push
> >                                             set_request(SOFT_FULL);
> >           clear_request(SOFT_FULL);                                <--- can wrongly clear the request?
> >
> 
> Hmmm, well spotted. That's another ugly effect of the recycle thread
> playing with someone else's toys.
> 
> > But I don't think that's a huge matter, as it'll just let the vcpu to have
> > one more chance to do another round of KVM_RUN.  Normally I think it means
> > there can be one more dirty GFN (perhaps there're cases that it can push >1
> > gfns for one KVM_RUN cycle?  I never figured out the details here, but
> > still..) pushed to the ring so closer to the hard limit, but we have had a
> > buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
> > that's still fine, but maybe worth a short comment here?
> > 
> > I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
> > cycle.  It would be good if there's an answer to that from anyone.
> 
> This is dangerous, and I'd rather not go there.
> 
> It is starting to look like we need the recycle thread to get out of
> the way. And to be honest:
> 
> +	if (!kvm_dirty_ring_soft_full(ring))
> +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> 
> seems rather superfluous. Only clearing the flag in the vcpu entry
> path feels much saner, and I can't see anything that would break.
> 
> Thoughts?

I've no objections to dropping the clear on reset, I suggested it primarily so
that it would be easier to understand what action causes the dirty ring to become
not-full.  I agree that the explicit clear is unnecessary from a functional
perspective.
