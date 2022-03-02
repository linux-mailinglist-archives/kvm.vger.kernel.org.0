Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA8C4CB29E
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 23:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiCBW54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 17:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiCBW5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 17:57:53 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760DD11594D
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 14:56:59 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t5so3204954pfg.4
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 14:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x9wMKym9S9fXqEpB7R7eZDSTX7z54wGdD8KBKn9vuvI=;
        b=EgHj1lPuwxxF7nT8U4wKaQR+RaYO9IipnSX48Gc/qLTii8qz4a6RlGCPMChRxH6QdR
         MiGQ4u3fOj6GLOfPtYyUVGCIQWox9k2+UNT/zY2BzqTpiCsB8mIdQXe+Zo5ICbusEpna
         YzJnp/92tZ23nkB/aufnwSe1JUu9dkb9ClKI867FycqPuhmDpC+W7Wis3c5Jy8Q59V/W
         BCl7QPyx0YCdKs6jU9BT5ja1Icf7uA11O1lMBc4leN+MsVZ5XLDH8OVLrGFHmYerMfRX
         84hbGQYB4qBseyAn/01vvvxpz2OOSANZJJhoLx5HsyjHYt7Sl3a/5NaThrjHlSnauAnx
         PYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x9wMKym9S9fXqEpB7R7eZDSTX7z54wGdD8KBKn9vuvI=;
        b=PtyUwioN3+mWXiBjVNJxZorYyIy+ZKIJQIuozE0g9dXf6bnXovWOEng/SsqwSjpX7I
         005yEVfxIKzEu2TFjYO8ayEHj9m6Ab+2cEntREiSIx/k8qLiuTpDq+QVgMYHPu+YFU6r
         PPIjqMs3hg1Bjcx5F0nqN3zJv4b3MMwdOUbLt7TVrmLpOsf5lGabv/wh4q10YD+BHzQf
         KyYKJyCwrXN2k3gaLTspkiE/nlHn766YVMK+Si9tbt6qiq+6FBHrZb4fbxd47JWmjvyi
         6A10oWSQkPCJB9xwbq6DLgugiC9vt6HiSmQjXqPB3ivH7l759ewwq2ICBbnDsT8IrsZe
         9L1w==
X-Gm-Message-State: AOAM533cgTg39YvPUy/lndVkFhDEfWm5G9MduOCYhnMhHqkX13terCq+
        1J0nWAWVur7FO44eGT8ROKtmjQ==
X-Google-Smtp-Source: ABdhPJxZJO0b6xynoVXwPfQ0Dg+QdrERgWdHdWjhBdS87LJkX73MUHodq13VvntY/QyAQPgmiXnHkg==
X-Received: by 2002:a05:6a00:d4c:b0:4e0:27dd:37c1 with SMTP id n12-20020a056a000d4c00b004e027dd37c1mr35550899pfv.86.1646261640293;
        Wed, 02 Mar 2022 14:54:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s2-20020a056a001c4200b004f41e1196fasm221880pfw.17.2022.03.02.14.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 14:53:59 -0800 (PST)
Date:   Wed, 2 Mar 2022 22:53:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: x86/mmu: Zap only obsolete roots if a root
 shadow page is zapped
Message-ID: <Yh/1hPMhqeFKO0ih@google.com>
References: <20220225182248.3812651-1-seanjc@google.com>
 <20220225182248.3812651-5-seanjc@google.com>
 <40a22c39-9da4-6c37-8ad0-b33970e35a2b@redhat.com>
 <ee757515-4a0f-c5cb-cd57-04983f62f499@redhat.com>
 <Yh/JdHphCLOm4evG@google.com>
 <217cc048-8ca7-2b7b-141f-f44f0d95eec5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <217cc048-8ca7-2b7b-141f-f44f0d95eec5@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> On 3/2/22 20:45, Sean Christopherson wrote:
> > AMD NPT is hosed because KVM's awful ASID scheme doesn't assign an ASID per root
> > and doesn't force a new ASID.  IMO, this is an SVM mess and not a TDP MMU bug.
> 
> I agree.
> 
> > In the short term, I think something like the following would suffice.  Long term,
> > we really need to redo SVM ASID management so that ASIDs are tied to a KVM root.
> 
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c5e3f219803e..7899ca4748c7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3857,6 +3857,9 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu,
> hpa_t root_hpa,
>         unsigned long cr3;
> 
>         if (npt_enabled) {
> +               if (is_tdp_mmu_root(root_hpa))
> +                       svm->current_vmcb->asid_generation = 0;
> +
>                 svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
>                 vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> 
> Why not just new_asid

My mental coin flip came up tails?  new_asid() is definitely more intuitive.

> (even unconditionally, who cares)?

Heh, I was going to say we do care to some extent for nested transitions, then
I remembered we flush on every nested transition anyways, in no small part because
the ASID handling is a mess.
