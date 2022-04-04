Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1204F1B8F
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380122AbiDDVV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378995AbiDDQQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 12:16:59 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E87381A7
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 09:15:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso3598389pjb.2
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 09:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UDaFc/gCWuOOIEIKSF8jU4oDzdusj5ZcLS5tUBZDl7k=;
        b=frLsqAzRoYQqPwY+LRr2+HLI4jsKjK8C88V/3rKXepEUVWcXYPUnN5f9Pbs3dFMgDM
         Fc30h7pCDhpRwEn5077MIjbu8eQViUZ4qp9RmklJtufdy1qVzWiDv1Gf/LObmGzWqjTS
         HCWymOlS/s7S1a2yT6yWZEAkvMUp+M3Hn8h4fTif3xSBCHn8nTYGCaCA67mey8IOTRKj
         vgrzwhMT9QUNrAUPk8GLVatbpq5t5kFHea5ElJA4/aZLkOiQZjJu3Isr9yB1FhxvX0wn
         zipj7LrlHsMAnXmylLn31UO3wAqFnLGS4noeL4O/zzmPw6SE2DvaX+X/D9LvxWpUoqdH
         nPfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UDaFc/gCWuOOIEIKSF8jU4oDzdusj5ZcLS5tUBZDl7k=;
        b=f/gPiXtMr3pj+eU1deYulhlx/IqqgTOL5zBRYkCPDZyfJLxcrxZGkms/nFZiwxHmGb
         rVIGT40hGxXRbg9ctCvQR/j/GBCqLE9PO8Y1SVrYBmB1F+kcSiIzO/nczdD7y/KcbwWh
         MhXijYwVmXL93Iy3aGmXhdfPEAoUGYPz7rBqu3mY8mRLA2ErVzEKDOS/7xOeJMPjNlKu
         8BXHTwF6GCgqkDVthgmyGQB0kzAXArPu0FjoTukSgpRR6CwCQS3srx2IOy091CwbKOwg
         CIUOPaiW74Xnq/g1yLT3qigIWSDUCt48po844FGqojdpR8j9wCIeRSFD6+IBO/PeVHHs
         kLwQ==
X-Gm-Message-State: AOAM531owIlHZhlN9E/xCqOFYvhnhrhQtn7cXpFcxPRf0rAZgE0c03Aw
        6hqhW7Lh5i8hwrxzH/HDWYoG8Q==
X-Google-Smtp-Source: ABdhPJxce26+IV6N/hp+MS7aKDXMfZboRNVcH0s2b8IdhwQqCgufgWGYQ6gNex6ufjHM6ZKhk0Gwlg==
X-Received: by 2002:a17:902:7615:b0:156:1859:2d00 with SMTP id k21-20020a170902761500b0015618592d00mr612139pll.126.1649088898855;
        Mon, 04 Apr 2022 09:14:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q18-20020aa78432000000b004fb0a5aa2c7sm13195487pfn.183.2022.04.04.09.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 09:14:58 -0700 (PDT)
Date:   Mon, 4 Apr 2022 16:14:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 7/8] KVM: x86: Trace re-injected exceptions
Message-ID: <YksZfqZr4SyEUk6H@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-8-seanjc@google.com>
 <df8e53474fb161f83c8cb8b9816995b23798545b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df8e53474fb161f83c8cb8b9816995b23798545b.camel@redhat.com>
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

On Mon, Apr 04, 2022, Maxim Levitsky wrote:
> On Sat, 2022-04-02 at 01:09 +0000, Sean Christopherson wrote:
> > Trace exceptions that are re-injected, not just those that KVM is
> > injecting for the first time.  Debugging re-injection bugs is painful
> > enough as is, not having visibility into what KVM is doing only makes
> > things worse.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 7a066cf92692..384091600bc2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9382,6 +9382,10 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
> >  
> >  static void kvm_inject_exception(struct kvm_vcpu *vcpu)
> >  {
> > +	trace_kvm_inj_exception(vcpu->arch.exception.nr,
> > +				vcpu->arch.exception.has_error_code,
> > +				vcpu->arch.exception.error_code);
> > +
> 
> Can we use a {new tracepoint / new parameter for this tracepoint} for this to
> avoid confusion?

Good idea, a param to capture re-injection would be very helpful.
