Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEABC502F4F
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 21:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344729AbiDOTbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 15:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbiDOTbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 15:31:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F11A88B21
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 12:28:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso9053185pjj.2
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 12:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eUrvYoxWcoMjJTRdZPr3oeY5u9guqwH3tZ5GuNaYx7U=;
        b=Vk7K6fZTZFll6XtApMqs8xP7Hx85zIwyRZnCE1pIqG7nIULID4SYG9XOWr/uP6jwZK
         vwrCZsK/OBjR3jl2xhkKNZpLUhtpz5sJ+6pQ/PPloPdoiZ7eSfUpGfTcVw3Rb94hd56R
         XwGuzudWmlD5umOFSLHJ8ZPcNFaS8IIWiErOPHK7R2VLv8unWJX+Qc5XAuEv/LclBLNQ
         mCBD7ZWAEB9Pqmc2jterTdMcY+VF1ebgZzUCcrpUKuhRdCfnc6qanUkG5d/DjYiAZy00
         61yKqexpkyd7lIuK/qffNk41To6xqk6cfr29y0DJdHuhyrZbeyDOH8AWYx8G9pU3Dl26
         YEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eUrvYoxWcoMjJTRdZPr3oeY5u9guqwH3tZ5GuNaYx7U=;
        b=DyjmaVlZVFZ6+KIg9WFOcUk1A0vzc5WCg8Pkmi4VqZGqC3NhoEnR+xy85R7M8XIxNt
         MtNVT94aglz5w5UuUsWQdPFjIw31EPqJEiGD9dYCsGu3JU0C/kXGHk7bQ0cMGhVaOfuD
         0cmFsI2FiG92LbixUMBlVV7fvByLAv3HaRsoYMQqAw4KhlL0foeMK0CiUJLwna71YE5v
         KEduCfMIdUCaJpPqWmxS8eGWhCFkRrjuGKmLLjQJYZK9z5FFZK159PzOERuAlXPexMVz
         PNKeHxPca6ADJ8xqNgboJ3xDGraNLREgxMzRiLklZLLZ8NrLvcSi2+sGuZECh6RQNJqt
         sV1A==
X-Gm-Message-State: AOAM530wxww+X2vaA6D2PjJfu2zne8Jt3xiYcygGC26o3FZww3cLqpn4
        s6Txe7Qdh/CJvENY21s4ILg7FQ==
X-Google-Smtp-Source: ABdhPJyr4wg4s6fJ6EJayU2i0zquccnP1F93DDXS5prnENGkdFFMS6YXwzru3Db+TnpBZMaEZiLhuQ==
X-Received: by 2002:a17:902:ec81:b0:158:7eff:792f with SMTP id x1-20020a170902ec8100b001587eff792fmr570376plg.154.1650050919452;
        Fri, 15 Apr 2022 12:28:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nm5-20020a17090b19c500b001cb9ba78d39sm5375187pjb.9.2022.04.15.12.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 12:28:38 -0700 (PDT)
Date:   Fri, 15 Apr 2022 19:28:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add RET_PF_CONTINUE to eliminate bool+int*
 "returns"
Message-ID: <YlnHY1Du8jqYUFQM@google.com>
References: <20220415005107.2221672-1-seanjc@google.com>
 <CALzav=errSO8+EpeXE3F1CVbmttDqBigzJRGWc2UBU9=NLvtjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=errSO8+EpeXE3F1CVbmttDqBigzJRGWc2UBU9=NLvtjw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022, David Matlack wrote:
> On Thu, Apr 14, 2022 at 5:51 PM Sean Christopherson <seanjc@google.com> wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 1bff453f7cbe..c0e502b17ef7 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -143,6 +143,7 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
> >  /*
> >   * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
> >   *
> > + * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
> >   * RET_PF_RETRY: let CPU fault again on the address.
> >   * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
> >   * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
> 
> RET_PF_CONTINUE and RET_PF_INVALID are pretty similar, they both
> indicate to the PF handler that it should keep going. What do you
> think about taking this a step further and removing RET_PF_INVALID and
> RET_PF_CONTINUE and using 0 instead?

RET_PF_INVALID is useful because it allows kvm_mmu_page_fault() to sanity check
that the page fault handler didn't barf:

		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
					  lower_32_bits(error_code), false);
		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
			return -EIO;

It's a bit odd that fast_page_fault() returns RET_PF_INVALID instead of RET_PF_CONTINUE,
but at the same time the fault _is_ indeed invalid for fast handling.

> That way we can replace:
> 
>   if (ret != RET_PF_CONTINUE)
>           return r;
> 
> and
> 
>   if (ret != RET_PF_INVALID)
>           return r;
> 
> with
> 
>   if (r)
>           return r;
> 
> ?

We could actually do that now, at least for RET_PF_CONTINUE, but I deliberately
avoided doing that so as to not take a hard dependency on the underlying value of
RET_PF_CONTINUE.  KVM's magic "0 == exit to userspace, 1 == resume guest" logic
is dangerous, e.g. it's caused real bugs in the past.  But in that case, the
return value is multiplexed with -errno, i.e. there's a good reason for using
magic values.

For this code, there's no such requirement because the caller must convert the
RET_PF_* return to the aforementioned magic returns.

And the even bigger motivation was to discourage "if (r)" for this case because
that suggests that this code _does_ utilize KVM's magic return value.  I actually
wrote it that way at first and then got completely turned around and forgot what
value was being returned :-)

Heh, and thinking about it, I'd be tempted to assign RET_PF_CONTINUE a non-zero
value if some debug Kconfig is enabled to really enforce that KVM explicitly checks
for RET_PF_CONTINUE instead of assuming a non-zero value means "bail".

> > @@ -151,9 +152,15 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
> >   *
> >   * Any names added to this enum should be exported to userspace for use in
> >   * tracepoints via TRACE_DEFINE_ENUM() in mmutrace.h
> 
> Please add RET_PF_CONTINUE to mmutrace.h, e.g.
> 
>   TRACE_DEFINE_ENUM(RET_PF_CONTINUE);
> 
> It doesn't matter in practice (yet) since the trace enums are only
> used for trace_fast_page_fault, which does not return RET_PF_CONTINUE.
> But it would be good to keep it up to date.

Drat, missed that.  Thanks!
