Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FFA536632
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 18:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbiE0Qz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 12:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbiE0Qzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 12:55:55 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C5EED70D
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 09:55:55 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d20so974969pjr.0
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 09:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sKFxmtwGGsPy+NVlph044vaLdYD4TxknLNpPic4NnnY=;
        b=GqDUoiaKcwigO2DEhLjqBvb4r5FmK2tmtJfSMr0APdzg6TF+ACYwTyjoVWvkOA/qQS
         TDZzTRb6BpH2LDYyy3oJj3mFWIr87g82j+wAQuvAm9dcFTCyCR6r/NycRUBO15k7hPc5
         2Lt7/Y3UwGiEvCNtTC02Y3mWB1nETR5YgJVpRwduX7g11tvXXyBbm7JQYZbXVHRyQdQO
         SFXfpRXYK/MwlGGsLlEGwXLxAed9TVrb9ouThHbnTNOvoKvPEBrY6K/5FD2ylolvA+dq
         gapI/D5BpSC6Wc/I0GaUB8dlDcKR8AVc4bigD4JhYZDYv08tlR2f/CQQuGREqCBo/bLE
         fgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sKFxmtwGGsPy+NVlph044vaLdYD4TxknLNpPic4NnnY=;
        b=NT4fR7dR4EbTsar8yIIU2gh8V2wMjBACnpF8A0JOP7wOJLc7iyhhzKhqbB/miV5uVy
         HCC0YlHMR3bG3bP1d5d5swiMfI0u+Qe/x7Gze2wdzz/LRdCTOFae3Q9czzpZxvtAF+E0
         Sn8HrgxvCZgYxyg9d02oNZgKgl8XLBHw2dtKtUq+srYn6vLJLHMJj05D7KQXJShlfc7N
         BJRrqLi24C4oFBA924u+ckLWigejeRnxSTN1IXWq2zo19T/65B/0k8XI4F5h0gkfe8eH
         yVbQPf+kww6vgrnAEIoceYnacDKaksJbnKaK6KsAoSE9WbhbhnMAfmFTT7+yngA9rFb9
         Cqdg==
X-Gm-Message-State: AOAM530ELzu8+kmomQG7GDbyBdtNONeQNISqa3EHmzRYCvSsk9opwzoL
        9X7ohOQEfwPjoJYI1IEwR6q2FQ==
X-Google-Smtp-Source: ABdhPJwOKkDli+AK+o0ziI6ImJHacFYk7+qDE+ZuUp4Zbi+DYb48yq30OfYy5UmkoBA+1NPL7sX+ng==
X-Received: by 2002:a17:90b:2241:b0:1e0:84aa:52ca with SMTP id hk1-20020a17090b224100b001e084aa52camr9266444pjb.100.1653670554548;
        Fri, 27 May 2022 09:55:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a67-20020a624d46000000b0050dc7628168sm3798211pfb.66.2022.05.27.09.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 09:55:54 -0700 (PDT)
Date:   Fri, 27 May 2022 16:55:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <YpEClgWsPWjcTy/O@google.com>
References: <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com>
 <YiAdU+pA/RNeyjRi@google.com>
 <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
 <YiDps0lOKITPn4gv@google.com>
 <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
 <YiFS241NF6oXaHjf@google.com>
 <764d42ec-4658-f483-b6cb-03596fa6c819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <764d42ec-4658-f483-b6cb-03596fa6c819@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

/cast resurrect

On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> On 3/4/22 00:44, Sean Christopherson wrote:
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> > index c92cea0b8ccc..46dd1967ec08 100644
> > --- a/arch/x86/kvm/vmx/nested.h
> > +++ b/arch/x86/kvm/vmx/nested.h
> > @@ -285,8 +285,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
> >  }
> > 
> >  /* No difference in the restrictions on guest and host CR4 in VMX operation. */
> > -#define nested_guest_cr4_valid nested_cr4_valid
> > -#define nested_host_cr4_valid  nested_cr4_valid
> > +#define nested_guest_cr4_valid kvm_is_valid_cr4
> > +#define nested_host_cr4_valid  kvm_is_valid_cr4
> 
> This doesn't allow the theoretically possible case of L0 setting some
> CR4-fixed-0 bits for L1.  I'll send another one.

Ha!  My "patch" is correct.  kvm_is_valid_cr4() calls vmx_is_valid_cr4(), which
calls nested_cr4_valid() when the vCPU is post-VMXON, so it _does_ cover the fixed0
case.  I'll send a proper patch with a comment to call out that subtlety.
