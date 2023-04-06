Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21876D8CC7
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 03:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbjDFBdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 21:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjDFBds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 21:33:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7922D7AA6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 18:33:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w5-20020a253005000000b00aedd4305ff2so37651562ybw.13
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 18:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680744823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jsB/tfJC8ap0Q2vMgBDSzt2I2z+/E5kN7b05VM1kkFA=;
        b=GWasBeuRCyfLP/2nY3G5VxWvQzDD35cw+Ar9E4Wi5+mZ2IPhqs6gUgJmWK18S7M9CQ
         7A6KRExSQ0LcXEQkvKjy8lvS1N+ymWUEEPgxwK+ei2nHon3TWtwXHE4BEeHS/5ifn3M+
         hGhHtBuSFqgTr6TrWBidfP5UXPZHY4pL9bak7LrhlfgubD+If41EFBqoOD7IrM6sdRJK
         0VWwQOse9yldokTR26ioqL+okOFWkCslY3x7VbIbhQzhe5wTwsKpqtum20SVUKk9hVRf
         rAYBwi0RGWvBvgXp85P79ZHzGvj8jTSCKhJt0GpD8aqlE53FoJkWT3o0TLaN8czf2JFb
         1O6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680744823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jsB/tfJC8ap0Q2vMgBDSzt2I2z+/E5kN7b05VM1kkFA=;
        b=EBXlyNIrsSLNt/o0vQckdJqzheC5kiGSyV70FQ1ozYE+xpo8PcL82yFMqtyjJ2DFLf
         kuQAQDGluVcgMqk8Xie+9KKp+0E7lDe1CDJUoXl7Wa3zfxTfvR5bERiPN4EKayjWhMWG
         YvD49N4zTl8T2qrfI4uhFyVadfOBIrxusXQ8MFw+VLJ79D2b8lJcki7cWv7AImT9b5E9
         EbE9M4GKvj7iyhqAdKAjrkwGJX29GGVQG3v/3jNaoM915rL/vQwZE2vG35O0ZBJEgiBn
         XbvpT6Lv7y4WV9PPazy8d8yZhnK3yrH9Oc///hllwpM7yGQZLexlq7l6zyffFrokO25K
         0uUQ==
X-Gm-Message-State: AAQBX9c/Elefec5MZw/TwyPDBWndeTd5jfVYMqykPw6H4F6mfBCrggNm
        v0QOL0daKFuxMC8mmEtf41sTb1d0GNo=
X-Google-Smtp-Source: AKy350YTiKtvFIPgdJlhLP+R/eSCJtf97r8mCuBYQ0UJ+1ii+gFFXJnnKJIL3RJP0+73acJNI8FYdcmmqfM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:909:b0:a27:3ecc:ffe7 with SMTP id
 bu9-20020a056902090900b00a273eccffe7mr985319ybb.3.1680744823563; Wed, 05 Apr
 2023 18:33:43 -0700 (PDT)
Date:   Wed, 5 Apr 2023 18:33:42 -0700
In-Reply-To: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
Mime-Version: 1.0
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <ZC4hdsFve9hUgWJO@google.com>
Subject: Re: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yuan Yao <yuan.yao@intel.com>,
        Eddit Dong <eddie.dong@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        Asit Mallick <asit.k.mallick@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023, Li, Xin3 wrote:
> The VMCS IDT vectoring information field is used to report basic information
> associated with the event that was being delivered when a VM exit occurred.
> such an event itself doesn't trigger a VM exit, however, a condition to deliver
> the event is not met, e.g., EPT violation.
> 
> When the IDT vectoring information field reports a maskable external interrupt,
> KVM reinjects this external interrupt after handling the VM exit. Otherwise,
> the external interrupt is lost.
> 
> KVM handles a hardware exception reported in the IDT vectoring information
> field in the same way, which makes nothing wrong. This piece of code is in
> __vmx_complete_interrupts():
> 
>         case INTR_TYPE_SOFT_EXCEPTION:
>                 vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
>                 fallthrough;
>         case INTR_TYPE_HARD_EXCEPTION:
>                 if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
>                         u32 err = vmcs_read32(error_code_field);
>                         kvm_requeue_exception_e(vcpu, vector, err);
>                 } else
>                         kvm_requeue_exception(vcpu, vector);
>                 break;
> 
> But if KVM just ignores any hardware exception in such a case, the CPU will
> re-generate it once it resumes guest execution, which looks cleaner.

That's not strictly guaranteed, especially if KVM injected the exception in the
first place.  It's definitely broken if KVM is running L2 and L1 injected an
exception, in which case the exception (from L1) doesn't necessarily have anything
at all to do with the code being executed by L2.  Ditto for exceptions synthesized
and/or migrated from userspace.

And as Paolo called out, it doesn't work for traps.  

There are also likely edge cases around Accessed bits and whatnot.

> The question is, must KVM inject a hardware exception from the IDT vectoring
> information field? Is there any correctness issue if KVM does not?

Yes.  I'm guessing if we start walking through the myriad flows and edge cases,
we'll find more.

> If no correctness issue, it's better to not do it,

In a vacuum, if we were developing a hypervisor from scratch, maybe.  It's most
definitely not better when we're talking about undoing ~15 years of behavior (and
bugs and fixes) in one of the most gnarly areas in x86 virtualization.  E.g. see 

  https://lore.kernel.org/all/20220830231614.3580124-1-seanjc@google.com

for all the work it took to get KVM to correctly handle L1 exception intercept,
and the messy history of the many hacks that came before.

In short, I am not willing to even consider such a change without an absolutely
insane amount of tests and documentation proving correctness, _and_ very strong
evidence that such a change would actually benefit anyone.
