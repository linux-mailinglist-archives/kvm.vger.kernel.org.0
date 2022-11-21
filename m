Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5075D632CAE
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 20:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiKUTME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 14:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiKUTLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 14:11:41 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44086D32AA
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 11:11:40 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t17so10569856pjo.3
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 11:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v2Tj+w1DK8LzPuOuQoc7i/E26OtlkqVwU1PKRQe1Ni0=;
        b=M3aSxUpAsJMXxU8yivBjDMrlMJcpIiq425+atpkOgbWR/Srr8X29PKgSpW4IxkzKNg
         ewf5/JwYRixaslsd4JQoOIKZqbsQJFSigskMReMy8pZJR6nhELzqYwTA5s4bxNRAQQnH
         bmc6s79eYPqgaIiHN/n6zmjornz4trJkFxpFVp1yUEN5g5k/SS82n1KYUTaBpcdSsdT+
         mPG8WQ8ROZlG2+qm9aEfA/F8HVkhETefHfIlWAi3/o+197UZEY60m0ufKUR8gb5Nms0K
         6c0Jgkw3u95k9zFOkcPlJTsrbLJIjwY4DsrUDOTZetslhOgCDXY6uWcMxm7DB3SpiYXe
         il6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v2Tj+w1DK8LzPuOuQoc7i/E26OtlkqVwU1PKRQe1Ni0=;
        b=26vr9sZaA2DsQmpMJCSqP0aWXMQ1tMZzpoy+E6oUiZk+UXbRuXMtE88NgAoyfCbGOm
         7OuPEUhQ5ZNDyvhXSwAFGD7RXgJSy3nltq+cqVV6sqlvIrB1Cg/qpT92ZbMMNe2Jb83h
         fr4n4vI58kI2+aTLIb2wcx8Ns1ls80s6nni5n4ycbvytLH07XMPqUdM3poWpaGkG2OW5
         TOwrdTSDh4Xa3Y3b+Dobg+hE27MOdDRIc/DdsmzODEJgwdOJwR98yzYViRCrV4C59Cq7
         Xf/OsRegCouT6X2aGwWfQrw3EO2KoJVkh2apG8XoKLadihHsDSDrU9w0NdTHjkMXgq8s
         0lcQ==
X-Gm-Message-State: ANoB5pncQAEV9LyQ921VXki/thtAiV3bOegOtgMMS6ASlAdC1EH2zkWO
        UbAGhsWCJcSPFl/1jsEtOCbAYg==
X-Google-Smtp-Source: AA0mqf7qJf7sYKlhoHjG1tMtPadxw8549sEA70wKdvO4mpzVKH27W7yLZ29aUHy2SsEDVgksqoycWg==
X-Received: by 2002:a17:90a:ff84:b0:213:1e05:f992 with SMTP id hf4-20020a17090aff8400b002131e05f992mr696789pjb.191.1669057899654;
        Mon, 21 Nov 2022 11:11:39 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b12-20020a170903228c00b001811a197797sm10160998plh.194.2022.11.21.11.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 11:11:39 -0800 (PST)
Date:   Mon, 21 Nov 2022 19:11:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH v2 07/16] KVM: Store gfn_to_pfn_cache length as an
 immutable property
Message-ID: <Y3vNZ0Y3KUVsrFcM@google.com>
References: <20221013211234.1318131-1-seanjc@google.com>
 <20221013211234.1318131-8-seanjc@google.com>
 <f80338c90d90fcd2ae3c592c55a591b1d46e6678.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f80338c90d90fcd2ae3c592c55a591b1d46e6678.camel@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022, David Woodhouse wrote:
> On Thu, 2022-10-13 at 21:12 +0000, Sean Christopherson wrote:
> > From: Michal Luczaj <mhal@rbox.co>
> > 
> > Make the length of a gfn=>pfn cache an immutable property of the cache
> > to cleanup the APIs and avoid potential bugs, e.g calling check() with a
> > larger size than refresh() could put KVM into an infinite loop.
> 
> Hm, that's a strange hypothetical bug to be worried about, given the
> pattern is usually to have the check() and refresh() within a few lines
> of each other with just atomicity/locking stuff in between them.

Why do you say it's strange to be worried about?  The GPC and Xen code is all quite
complex and has had multiple bugs, several of which are not exactly edge cases.
I don't think it's at all strange to want to make it difficult to introduce a bug
that would in many ways be worse than panicking the kernel.

But as Paolo said, the APIs themselves are to blame[*], check() and refresh()
shouldn't be split for the common case, i.e. this particular concern should largely
be a non-issue in the long run.

[*] https://lore.kernel.org/all/c61f6089-57b7-e00f-d5ed-68e62237eab0@redhat.com

> I won't fight for it, but I quite liked the idea that each user of a
> GPC would know how much space *it* is going to access, and provide that
> length as a required parameter. I do note you've added a WARN_ON to one
> such user, and that's great — but overall, this patch makes that
> checking *optional* instead of mandatory.

I honestly don't see a meaningful difference in this case.  The only practical
difference is that shoving @len into the cache makes the check a one-time thing.
The "mandatory" check at use time still relies on a human to not make a mistake.
If the check were derived from the actual access, a la get_user(), then I would
feel differently.

Case in point, the mandatory check didn't prevent KVM from screwing up bounds
checking in kvm_xen_schedop_poll().  The PAGE_SIZE passed in for @len is in no
way tied to actual access that's being performed, the code is simply regurgitating
the size of the cache.

> > All current (and anticipated future) users access the cache with a
> > predetermined size, which isn't a coincidence as using a dedicated cache
> > really only make sense when the access pattern is "fixed".
> 
> In fixing up the runstate area, I've made that not true. Not only does
> the runstate area change size at runtime if the guest changes between
> 32-bit and 64-bit mode, but it also now uses *two* GPCs to cope with a
> region that crosses a page boundary, and the size of the first
> therefore changes according to how much fits on the tail of the page.
> 
> > Add a WARN in kvm_setup_guest_pvclock() to assert that the offset+size
> > matches the length of the cache, both to make it more obvious that the
> > length really is immutable in that case, and to detect future bugs.
> ...
> > @@ -3031,13 +3030,13 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
> >  	struct pvclock_vcpu_time_info *guest_hv_clock;
> >  	unsigned long flags;
> >  
> > +	WARN_ON_ONCE(gpc->len != offset + sizeof(*guest_hv_clock));
> > +
> 
> That ought to be 'gpc->len < offset + sizeof(*guest_hv_clock)' I think?
> 
> In the case where we are writing a clock *within* a mapped Xen
> vcpu_info structure, it doesn't have to be at the *end* of that
> structure. I think the xen_shinfo_test should have caught that?

The WARN doesn't get false positive because "struct pvclock_vcpu_time_info" is
placed at the end of "struct vcpu_info" and "struct compat_vcpu_info".
 
I don't have a strong opinion on whether it's "!=" of "<", my goal in adding the
WARN was primarily to show that @len really is immutable in this case.  Guarding
against future overrun bugs was a bonus.
