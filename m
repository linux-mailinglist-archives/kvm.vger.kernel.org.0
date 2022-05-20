Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA2852F46C
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 22:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353465AbiETUaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 16:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbiETUad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 16:30:33 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7E9185CBA
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 13:30:32 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id bh5so8258541plb.6
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 13:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iTfEbxhEPE+I25BZ4CZtl8Ad8yWflp0UHaW5WO5m8b4=;
        b=H0xt++lZPCBFEgu1tOl35h8wuLpVcLdkrjqaUjvsezsw8IAIsh+NlwHQUtyoMvqBwt
         Qz/0gCIcR8haYgdvwk3UbFZ2j08fgJNNCcPdMQClFxCS9s7ILTqUOjphICYgN1cfERaM
         cT68xElFHVAPvvCYdtgOrYKHB+phRPNWU9k8RXO8AQKoLHUz87hT2lV3PzX41tUIzxuC
         Hn/Jp1Qplf6b+uVzXRqtQxKLYSQB2gy0F0mL7bIu+YVGX4s1onV2gVrm5JNSgfV+xtes
         fEQjNttnzEm/aQ6vK+Kw5rnbcdFIhP6D2yOPxO6Hv6iLKivCaE/o+Jzt+NobVFezSY3K
         RG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iTfEbxhEPE+I25BZ4CZtl8Ad8yWflp0UHaW5WO5m8b4=;
        b=TtbrzfnpAzc8dBsI8rUa28AawtXFYs7JJDDlBBCvcp19Eof4WbeheKz0YEF7MT2EZf
         0ukOvu/yhS5za5on4mLOu3mPNvQTXnWZhnUpOzbLQ3qfxyFu7gffn+pZ4/bjn2AW8Xs5
         LVkxxf2kHijGcCyh6mwPAQUOgZvBAQYztqeqc1grzocYZ9A1BF1Ug+WsJwmoQAYgrpOx
         CYpBc4kEXa7nxPmygjHagbONA/7eG2aYb65v8otmnGI8x5/mTjlVsb90G2qIz3N/uLGu
         iqYzoP7BLU+BX2kQj/Be1WDL95mS7oGJAKx3TrFICWQIxpTmqvshj3C/12XDbKtgU1Se
         yqOA==
X-Gm-Message-State: AOAM530S8iIDsUor20aVlP2b9YNBrm22B8n/hn89/6yrP/m6gZABaMFv
        8j5YDQrI6LqPQByvKGKlpaYnFQ==
X-Google-Smtp-Source: ABdhPJwCW+H5drei/Y3koNBBrYJL9KXkStLFqNivgykiATwBpEWfIpk6PUuWHHx16P7XEm0KS4XgWQ==
X-Received: by 2002:a17:902:f08d:b0:161:d786:8694 with SMTP id p13-20020a170902f08d00b00161d7868694mr10797410pla.77.1653078632042;
        Fri, 20 May 2022 13:30:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i198-20020a6287cf000000b005180c127200sm2301111pfe.24.2022.05.20.13.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 13:30:31 -0700 (PDT)
Date:   Fri, 20 May 2022 20:30:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Message-ID: <Yof6ZE0IjSAL+iO8@google.com>
References: <20220512174427.3608-1-jon@nutanix.com>
 <YoRPDp/3jfDUE529@google.com>
 <29CDF294-5394-47C7-8B50-5F1FC101891C@nutanix.com>
 <732266F9-9904-434A-857F-847203901A0C@nutanix.com>
 <Yof0sSy/xKrCY5ke@google.com>
 <13E3F717-2938-430F-BA8B-70DD87962344@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13E3F717-2938-430F-BA8B-70DD87962344@nutanix.com>
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

On Fri, May 20, 2022, Jon Kohler wrote:
> 
> 
> > On May 20, 2022, at 4:06 PM, Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Fri, May 20, 2022, Jon Kohler wrote:
> >> 
> >>> On May 18, 2022, at 10:23 AM, Jon Kohler <jon@nutanix.com> wrote:
> >>> 
> >>>> On May 17, 2022, at 9:42 PM, Sean Christopherson <seanjc@google.com> wrote:
> >>>>> +		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) && data == BIT(0)) {
> >>>> 
> >>>> Use SPEC_CTRL_IBRS instead of open coding "BIT(0)", then a chunk of the comment
> >>>> goes away.
> >>>> 
> >>>>> +			vmx->spec_ctrl = data;
> >>>>> +			break;
> >>>>> +		}
> >>>> 
> >>>> There's no need for a separate if statement.  And the boot_cpu_has() check can
> >>>> be dropped, kvm_spec_ctrl_test_value() has already verified the bit is writable
> >>>> (unless you're worried about bit 0 being used for something else?)
> >> 
> >> I was (and am) worried about misbehaving guests on pre-eIBRS systems spamming IBRS
> >> MSR, which we wouldn’t be able to see today. Intel’s guidance for eIBRS has long been
> >> set it once and be done with it, so any eIBRS aware guest should behave nicely with that.
> >> That limits the blast radius a bit here.
> > 
> > Then check the guest capabilities, not the host flag.
> > 
> > 	if (data == SPEC_CTRL_IBRS &&
> > 	    (vcpu->arch.arch_capabilities & ARCH_CAP_IBRS_ALL))
> 
> So I originally did that in my first internal patch; however, the code you wrote is
> effectively the code I wrote, because cpu_set_bug_bits() already does that exact
> same thing when it sets up X86_FEATURE_IBRS_ENHANCED. 
> 
> Is the boot cpu check more expensive than checking the vCPU perhaps? Otherwise,
> checking X86_FEATURE_IBRS_ENHANCED seemed like it might be easier
> understand for future onlookers, as thats what the rest of the kernel keys off of
> when checking for eIBRS (e.g. in bugs.c etc). 

Cost is irrelevant, checking X86_FEATURE_IBRS_ENHANCED is simply wrong.  Just
because eIBRS is supported in the host doesn't mean it's advertised to the guest,
e.g. an older VM could have been created without eIBRS and then migrated to a host
that does support eIBRS.  Now you have a guest that thinks it needs to constantly
toggle IBRS (I assume that's the pre-eIBRS behavior), but by looking at the _host_
value KVM would assume it's a one-time write and not disable interception.
