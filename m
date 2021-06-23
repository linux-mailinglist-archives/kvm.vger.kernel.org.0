Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6366E3B22EC
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 00:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFWWKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 18:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWWKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 18:10:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B28C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 15:08:19 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k5so2297384pjj.1
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 15:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=44Yf6cLjs99O4uIqpzkWbsq5gnf+DtkSEt/XegXpG6E=;
        b=tk8J7oMyp9qjr6rPOSZQv6b8CsU+QLFvOCYQP2w2ox008byz7djyW8OtDLw4NkY7Aj
         0iGS0FBtuO4NZkAVq/7AI6EPLnwYQdiiXsU4PlQ364srB9dVikV1BSzwD+RxgKkSzC3t
         nFWwB5kS8HEe5pmq90yED4WO7Q/rJ8fLsA1y1FZnanUX/o9ptOhjEjtOjshrGno1jAh8
         xSakJk4hjtsCOxppj/DEFeO02d2YnTn8TuGI08rz7qq4koQfFvym4rZ7XDleDkdM4tYq
         ZSWZdv9Qf67uVmC/N2NugKz6e8lecWaG9b0ZSvpOYvetszdUAMkU1Ty/RcT8Bug06KY1
         Zakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=44Yf6cLjs99O4uIqpzkWbsq5gnf+DtkSEt/XegXpG6E=;
        b=TN7+grAmABkMgKcEsEtVEzrRGjyAsPSEm/egKuOS96/BKQS5E52pn33gTjng/OyVi/
         NYzi4cpdzuzpoJrlqnsDw2JbSW8h8Fhne12nbAdlCkcMmueXAYlqsoLJPJnKfvW7hAAc
         G2Kl/veYlHjIQh2Diz/LxNedacqJ/26bENqFr16vtDKo+X4KDRG+qTbQiXAhgY/Bvw6c
         PHH9ZUQitfsVs9io5gYZYZ8zP19vfeSEwwaI+jMJk9MH2xc95CZEf41Bq5kFaFzk/1HC
         ttZpWgHvigOmKpL5YrDLZZjN6KBOaRt+zs9w6x5TNPu/HBLy2VuRRmGeS7r5r1Hy5y+Z
         2/QA==
X-Gm-Message-State: AOAM533R4B4QEXv31NJH6yrtnLYqC+MKdUNWGsftpiCXZ+JBnMqKDk2f
        Enism47rZByCG7WlEe0+jsD2kQxoybgZQQ==
X-Google-Smtp-Source: ABdhPJw05HM2g2N8R13WyHgaeSGfcbunTji93ixugUtg+1FHkSDWB2SoqxWijlOGOapY0PK/2zrCAg==
X-Received: by 2002:a17:90a:7c4a:: with SMTP id e10mr1847755pjl.56.1624486099017;
        Wed, 23 Jun 2021 15:08:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gg5sm6017037pjb.0.2021.06.23.15.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 15:08:18 -0700 (PDT)
Date:   Wed, 23 Jun 2021 22:08:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 00/54] KVM: x86/mmu: Bug fixes and summer cleaning
Message-ID: <YNOwz4ln0MsI+/Ts@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <b4efb3fd-9591-3153-5a64-19afb12edb2b@redhat.com>
 <YNOiar3ySxs0Z3N3@google.com>
 <d9004cf0-d7ac-dc7d-06ad-6669fe11a21b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9004cf0-d7ac-dc7d-06ad-6669fe11a21b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 23/06/21 23:06, Sean Christopherson wrote:
> > > 
> > > This is good stuff, I made a few comments but almost all of them (all except
> > > the last comment on patch 9, "Unconditionally zap unsync SPs") are cosmetic
> > > and I can resolve them myself.
> > The 0-day bot also reported some warnings.  vcpu_to_role_regs() needs to be
> > static, the helpers are added without a user.  I liked the idea of adding the
> > helpers in one patch, but I can't really defend adding them without a user. :-/
> 
> Yep, I noticed them too.
> 
> We can just mark them static inline, which is a good idea anyway and enough

But they already are static inline :-(

> to shut up the compiler (clang might behave different in this respect for .h
> and .c files, but again it's just a warning and not a bisection breakage).

I was worried about the CONFIG_KVM_WERROR=y case.
