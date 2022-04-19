Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EBE507212
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 17:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354007AbiDSPsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 11:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354003AbiDSPsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 11:48:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B0BBF6E
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 08:45:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id n43so4689396pfv.10
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 08:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hcC70nEaEjCrZOBwR+bHJFoY8sXKM5tdaihGvVikeUA=;
        b=nllDsrmMLB7AAvdsCYhHwzGAwZygD09xcbijCyvxam19T71okMswczeidyoTR5SpG0
         rh2btGFKQ8mFqLW0jb05ZgH7OBBqFC3qd+RSoYqhjbcOEfsOApUER19sCRfFMfoBIpEI
         yKTQvKsy4m5GlAWzFu8NEv3LhxslcTTwe6M8afBDFsE8xE+g+gSVzSH2Y6X7wQTu3bZ0
         kdi4zB98HqqFf25muMksptD1m9ilqCPvrI6q21hqYsF4bYqxNptCkUe1YhNdH7I5dLV1
         d2lkK/LTT2KCvd4gEIWUsK4t0WNBMIpaja6VIf/jz4mIVCTT2/Ja8zo91SL4YY1Ex4Nu
         siWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hcC70nEaEjCrZOBwR+bHJFoY8sXKM5tdaihGvVikeUA=;
        b=wVeth6OTtPmTwp6U8zaJmkl+8qMsr/6iFah9osPeTmLEh9udy26yMfY5NdwtUlM99l
         Jsc1nU9kJ+KXe1Lh1ShLh6AGgyDRxDWK1wNtGptS7Xoigs6ygRrDlXGpxlXpPEiMthjI
         uha/eGxfjpXKkZ16MA3Sk9NLaIkRWUhihXh0CLMk0BzkHJmc6EXKsn0BltqjLp+wvRkB
         D1KDBnBJq8akmws8T/avzo8rlsz297Bqxu8XOvPzluGFO5o/rgeH9y7Zcf+rFQxEmDWw
         gCbxRhGesBmzPK9dCqt2JnuFwg9i3aehbn0BjbnHTCQjlu56y6dbDuz+jECb3ymBmIOH
         w33A==
X-Gm-Message-State: AOAM532+bmgixXMge8wWZP1ilGeXJ4cb36sEzHunyMtWtNu2+trs8nHP
        shgJtPkDBslwhilDHdh4w1X+Iw==
X-Google-Smtp-Source: ABdhPJxyLXIANNTGiAZfsu1/QG9UANwG5wKin3TjbnrIzeNo7+Th34xV36A6olC5ZeEiVQzlg55+OQ==
X-Received: by 2002:a05:6a00:b4d:b0:509:1ed1:570e with SMTP id p13-20020a056a000b4d00b005091ed1570emr18500672pfo.19.1650383157493;
        Tue, 19 Apr 2022 08:45:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z4-20020a17090a66c400b001d0e448810asm13613064pjl.36.2022.04.19.08.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 08:45:56 -0700 (PDT)
Date:   Tue, 19 Apr 2022 15:45:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: Add helpers to wrap vcpu->srcu_idx and yell if
 it's abused
Message-ID: <Yl7ZMJ/takmHh7tY@google.com>
References: <20220415004343.2203171-1-seanjc@google.com>
 <20220415004343.2203171-4-seanjc@google.com>
 <5b561bf1a0bbf140ea09d516f946a4e8fee8dd2d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b561bf1a0bbf140ea09d516f946a4e8fee8dd2d.camel@redhat.com>
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

On Tue, Apr 19, 2022, Maxim Levitsky wrote:
> On Fri, 2022-04-15 at 00:43 +0000, Sean Christopherson wrote:
> > Add wrappers to acquire/release KVM's SRCU lock when stashing the index
> > in vcpu->src_idx, along with rudimentary detection of illegal usage,
> > e.g. re-acquiring SRCU and thus overwriting vcpu->src_idx.  Because the
> > SRCU index is (currently) either 0 or 1, illegal nesting bugs can go
> > unnoticed for quite some time and only cause problems when the nested
> > lock happens to get a different index.
> > 
> > Wrap the WARNs in PROVE_RCU=y, and make them ONCE, otherwise KVM will
> > likely yell so loudly that it will bring the kernel to its knees.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---

...

> Looks good to me overall.
> 
> Note that there are still places that acquire the lock and store the idx into
> a local variable, for example kvm_xen_vcpu_set_attr and such.
> I didn't check yet if these should be converted as well.

Using a local variable is ok, even desirable.  Nested/multiple readers is not an
issue, the bug fixed by patch 1 is purely that kvm_vcpu.srcu_idx gets corrupted.

In an ideal world, KVM would _only_ track the SRCU index in local variables, but
that would require plumbing the local variable down into vcpu_enter_guest() and
kvm_vcpu_block() so that SRCU can be unlocked prior to entering the guest or
scheduling out the vCPU.
