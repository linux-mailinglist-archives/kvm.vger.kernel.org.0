Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2776A459512
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhKVSwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhKVSwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:52:50 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2607C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:49:43 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id r138so6493768pgr.13
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SxyojBVqeaMPTAohryY0gMBBMQdskNaj/27cUyyvEcg=;
        b=E/y1Pj2+aJIiLou8CqMiukr0R8bAAo39P9fIFHYiZAB1TbjdSALxZOu/gO4icwQ8HN
         pBq2gy9C88qNBjU0tP0xbnF09tj/Dbf4vubPmp0WhUVgggHeC7NAtiGNEWXcVGOlL6Y4
         /culURmitKhs75/Wv8X1cIsDFRrrDuJDp0g8Pz6B1xrlAoq/fcyjPEpMgWJDgaWqYz42
         4xTiCqJ+gCaQ4CgldXctQjTMcqEpZPM2bq+nfbKEY0LTn8qSIxz/XaqfJWs+lbtifW5Q
         TefNXpa/SGNaQMdTasIKZzRaE0aKbPfoLGx7mrLXu+V64e24O/jfu7dTEP70imdx7A1U
         pjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SxyojBVqeaMPTAohryY0gMBBMQdskNaj/27cUyyvEcg=;
        b=jPdGFckQsUhNL17nOFgu+QrzuaYs6j7PuSDpAFTwX/Rewjh07syhPczXZixMC6bBHA
         qNJYw4RLXU2hhYhZr0l7S1dNSdwJMfuqPxcjxR36cXgklrx8jIK7HEMyNhkmidMpKyT3
         UL5gQYYmx4xBkpgJKzjda5bEMERYofZOUkbKF/jk8aJ5yl6kNz9ayX9XIMFlp1Ag/6IK
         xuEkCImsqXpYFfNMD1pYMZZdYGZzmASSDEX7b4hjR/b2xGBrL7/rLCOC2c8bnJBz8Shs
         sQj4NaHcPJSwGTpWW4isYvrPZOb4BFF5ApRDf+vQWytjb0yATKSA6JECd2ejAzcIe4DB
         YLtA==
X-Gm-Message-State: AOAM531Dd8LafiVDZqi6S797BG1TRdirFCnjU2cLpIOkhEyHyBD0P4zo
        tBYwVqW/YBytrYLVeAU6WPJYfw==
X-Google-Smtp-Source: ABdhPJy6vQvpO9AA3EUN/NOxIUg/gapr34v5QUIwYSn7IPS6idN+DBYnD4AKQnVLingib+jUtEDqUQ==
X-Received: by 2002:a05:6a00:1991:b0:4a4:f002:66f0 with SMTP id d17-20020a056a00199100b004a4f00266f0mr8565162pfl.81.1637606983105;
        Mon, 22 Nov 2021 10:49:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oc10sm20851413pjb.26.2021.11.22.10.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 10:49:42 -0800 (PST)
Date:   Mon, 22 Nov 2021 18:49:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM: Warn if mark_page_dirty() is called without an active vCPU
Message-ID: <YZvmQjgdI/gQj6T6@google.com>
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
 <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
 <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
 <YZvNB0ByFmdEkUVX@google.com>
 <ee872549432eaf62c0c5a722b94ac4390ef3df83.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ee872549432eaf62c0c5a722b94ac4390ef3df83.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, David Woodhouse wrote:
> On Mon, 2021-11-22 at 17:01 +0000, Sean Christopherson wrote:
> > On Sat, Nov 20, 2021, David Woodhouse wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 6c5083f2eb50..72c6453bcef4 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3020,12 +3020,17 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> > >  			     struct kvm_memory_slot *memslot,
> > >  		 	     gfn_t gfn)
> > >  {
> > > +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> > > +
> > > +	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> > 
> > Maybe use KVM_BUG_ON?  And two separate WARNs are probably overkill.
> > 
> > 	if (KVM_BUG_ON(!vcpu || vcpu->kvm != kvm, kvm))
> > 
> > 
> > I'd also prefer to not retrieve the vCPU in the dirty_bitmap path, at least not
> > until it's necessary (for the proposed dirty quota throttling), though that's not
> > a strong preference.
> 
> I don't think that would achieve my objective. This was my reaction to
> learning that I was never supposed to have called kvm_write_guest()
> when I didn't have an active vCPU context¹. I wanted there to have been
> a *warning* about that, right there and then when I first did it
> instead of waiting for syzkaller to find it.

Fair enough.  And probably a moot point since Paolo hasn't vehemently objected
to the dirty quota idea.
