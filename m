Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B718A7707FD
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 20:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjHDSat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 14:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjHDSaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 14:30:07 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AA561AF
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 11:27:24 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5734d919156so24933837b3.3
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 11:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691173626; x=1691778426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yicl8HQWxQqj3w4wcqj/w2h6VZPy7YMSL4dCcW63iys=;
        b=zsme1DSz81gpIQfOQX3wWoXO8SQg5Lnsl9fwG2BcXHdEHPgZMpS84JTXH+7hjqVgJE
         EKfSAWA4vETl1TeMAThrU6X7RPzer1qGCKqD8O8c+I9I3lPwuFnv3RzZ8e2VBY0C2Aef
         Bw/vFmwYDQ4Qx4gaRkBU1N0+J5R6IoMe5iYtLihh23GfIdOCxMtHdRBVuQDp2RlSQtIG
         Q76cNr5/Zx4kmVoLQKFolxNb5noig4VtIwNqcwl45UZJAIl9Ep/uifXC3oJad8tNwvMk
         kqbqpHndaNRmyAPWZarfBpNq/Qrl8Byn7VMrbxsPxPVvqCF15sKOgPZCROJ5Ybba3lnl
         N67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691173626; x=1691778426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yicl8HQWxQqj3w4wcqj/w2h6VZPy7YMSL4dCcW63iys=;
        b=ZWy/AKmdDBgOluaxwt7mMN7BrSojU/1xg1b3fyDJwzntJvunxqxxNoIWOVNiQ9M7JR
         sZgk31o4Rm/95OdhXEk/IQBj4MBoMHdF/IsGdV5Tgw+D3xlih9u13QAEoNvljr5vh7s1
         3KYS//yKog972gcc5ZGiFxvH1dWkzM9SV2yKL8pj3PmupoZzU/MUdS/6/dtKR5fJZBlc
         xKxApxSqNV+IukvMYF/qiBc/o08ORzL3NKH7d5K4JhHvhLZWTpqzOfYWgKeYY9NYXs+s
         LIY2TiWBU7ooHOUYkqqIm6YpQsCte2kdB3wvokm83IRcEP4lCJkzabZ2SMb37fRH0FCY
         zm+w==
X-Gm-Message-State: AOJu0Yz0rPq4zvEI+5rANy8mrdVPrPcTJ3Em4fpgfw9dht1l3ruTy5lK
        Ia+jpaLOQ3cssMoMrbgjsCBPA4bfgYg=
X-Google-Smtp-Source: AGHT+IHoZUXVYbPP+MadD0iZRGDE0s1QJNlhExLbvmwhVTuvQVXgGPBmnTPtoHs7EIJYDdx+8/h9hEmhmmQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1588:b0:d3b:12d3:564e with SMTP id
 k8-20020a056902158800b00d3b12d3564emr14010ybu.2.1691173625936; Fri, 04 Aug
 2023 11:27:05 -0700 (PDT)
Date:   Fri, 4 Aug 2023 11:27:04 -0700
In-Reply-To: <20230803042732.88515-5-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com> <20230803042732.88515-5-weijiang.yang@intel.com>
Message-ID: <ZM1C+ILRMCfzJxx7@google.com>
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023, Yang Weijiang wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0b9033551d8c..5d6d6fa33e5b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3780,10 +3780,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>  		 * XSAVES/XRSTORS to save/restore PT MSRs.
>  		 */
> -		if (data & ~kvm_caps.supported_xss)
> +		if (data & ~vcpu->arch.guest_supported_xss)

Hmm, this is arguably wrong for userspace-initiated writes, as it would prevent
userspace from restoring MSRs before CPUID.

And it would make the handling of MSR_IA32_XSS writes inconsistent just within
this case statement.  The initial "can this MSR be written at all" check would
*not* honor guest CPUID for host writes, but then the per-bit check *would* honor
guest CPUID for host writes.

But if we exempt host writes, then we'll end up with another mess, as exempting
host writes for MSR_KVM_GUEST_SSP would let the guest coerce KVM into writing an
illegal value by modifying SMRAM while in SMM.

Blech.

If we can get away with it, i.e. not break userspace, I think my preference is
to enforce guest CPUID for host accesses to XSS, XFD, XFD_ERR, etc.  I'm 99%
certain we can make that change, because there are many, many MSRs that do NOT
exempt host writes, i.e. the only way this would be a breaking change is if
userspace is writing things like XSS before KVM_SET_CPUID2, but other MSRs after
KVM_SET_CPUID2.

I'm pretty sure I've advocated for the exact opposite in the past, i.e. argued
that KVM's ABI is to not enforce ordering between KVM_SET_CPUID2 and KVM_SET_MSR.
But this is becoming untenable, juggling the dependencies in KVM is complex and
is going to result in a nasty bug at some point.

For this series, lets just tighten the rules for XSS, i.e. drop the host_initated
exemption.  And in a parallel/separate series, try to do a wholesale cleanup of
all the cases that essentially allow userspace to do KVM_SET_MSR before KVM_SET_CPUID2.
