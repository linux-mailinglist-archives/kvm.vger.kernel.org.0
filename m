Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A183B4C174C
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242251AbiBWPnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242342AbiBWPnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:43:00 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12C92D1E5
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 07:42:32 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id d17so15709956pfl.0
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 07:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5eKMkbn3vkPpm7UY1+T/n4u23dYrThYK2hTdMcTSqbk=;
        b=iQzHOuBdRTgUUwt6x2XL6c8dfG05Yq2gL7QStu4+rU71gTwZCdVG62tkmnrcJ/f8dH
         zQcDF4w85f82eNBReN8+eMUSdqm5waegLQY0IJNLiNjN36p+1FuyVSmEaSe7kUixtrVV
         VB1yF9AAN0VGCT3TMx+zfqBN2hQ1DdRRM7EcMByLGE+QkDfDbbN2X8+o+i4np2ejbMbL
         Znzp7xrygfK0NJmiU89eEIQGozNaVvTJUs6eEHx/+tBNY7jg4mQrXTTQU4EmoCMkCRYP
         htRsgSUx6DkOhgpD32eQl1emvmhW19tNmjDmqL+Js+IARGf+990k4VCkK+vyZfmRlbTy
         k5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5eKMkbn3vkPpm7UY1+T/n4u23dYrThYK2hTdMcTSqbk=;
        b=oIQNl4NZFa8HruE5thkEEowNKy4ypqcdlrBMOg9B4ew/UYajXFXcGSv0xnPgYUWzyo
         ljFQPlu5Yv2XYB8XezmmuEgjgzfb7lthgpyX6B2YAjK0jto/nF2yG8yujS9jqryPcKF0
         sdDfG0OC3ulSv2VWOsOm0sEXEiuRzKWNsspGaBvzCFNUuVZWZJpoQpyeieH0ydhRSJ/Z
         tj0bp22+koBrLogpcZQ+tWSNOmdqt8j1MUJvKotkx1jTZWM9/EByseTGCchUrkSmBL21
         58gcZvu0V3tyLxI0T/xqx6665PB7UPPRllhpQreeMNXWAFrCVWyXcWql2eceiLhPV63i
         MLBA==
X-Gm-Message-State: AOAM531L9S8KikPhnpn/HunbZj+BCwx/tvuEJIFuFc3lHbT2W2E8W8yR
        7UTZ08MCqrMeTX5kv0Nk+a91KQ==
X-Google-Smtp-Source: ABdhPJwC6BFJXKTBBXCtBd1U+4hyOlzH0X/agA3nwjmP1Umj4h9d1LMS/fMMYwwkm2ORUHx4O6X1YA==
X-Received: by 2002:a62:fb0d:0:b0:4f1:a584:71f with SMTP id x13-20020a62fb0d000000b004f1a584071fmr10767700pfm.2.1645630951771;
        Wed, 23 Feb 2022 07:42:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s24sm24789695pgq.51.2022.02.23.07.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 07:42:31 -0800 (PST)
Date:   Wed, 23 Feb 2022 15:42:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 05/18] KVM: x86/mmu: use struct kvm_mmu_root_info for
 mmu->root
Message-ID: <YhZV4yFw5dk3N5o7@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-6-pbonzini@redhat.com>
 <cb338203d9abf040fc1b68763ce60369cc8342a6.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb338203d9abf040fc1b68763ce60369cc8342a6.camel@redhat.com>
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

On Wed, Feb 23, 2022, Maxim Levitsky wrote:
> On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b912eef5dc1a..c0d7256e3a78 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -762,7 +762,7 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
> >  	if ((fault->error_code & PFERR_PRESENT_MASK) &&
> >  	    !(fault->error_code & PFERR_RSVD_MASK))
> >  		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
> > -				       fault_mmu->root_hpa);
> > +				       fault_mmu->root.hpa);
> >  
> >  	fault_mmu->inject_page_fault(vcpu, fault);
> >  	return fault->nested_page_fault;
> 
> 
> As a follow up to this patch I suggest that we should also rename pgd to just 'gpa'.

Hmm, I prefer 'pgd' over 'gpa' because it provides a hint/reminder that the field
is unused for TDP.  It also pairs with e.g. kvm_mmu_new_pgd(), though I suppose we
could rename those to something else too.

> This also brings a question, what pgd acronym actually means? 
> I guess paging guest directory?

Page Global Directory, borrowed from the kernel's arch-agnostic paging terminology.
