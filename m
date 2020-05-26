Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520291E31F8
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 00:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390956AbgEZWEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 18:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389257AbgEZWEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 18:04:24 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCF0C03E96D
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 15:04:24 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id b6so26499909ljj.1
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 15:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EcBNTwy79MX3yH1H5a4QAnADWJ5Ti4Rl/SXJla0EyZ4=;
        b=1VIxdJkHliis/HUn7kq316YUDLh4+Gax6mufwNHGCFT1G4llvRD+JlR+C1zPJAUgFn
         Y84KKy5/naQ5pKU3rWyaP7bZBhhJg81lOYBD/edIYJjVlLOgu2R9SsPmTssYF4cpFHi1
         9yOuSit53nlS4vB+++Wb0879nmskyRucpXpsLKqnrBUJJ5mPGoHHNokeqdqWBylfiAmX
         svt6pUDPxlaBmafb7m7UTqFuO2amHz/cfyBELkKjWTb424FLyK5d4AQ/py2ymUcKXB7p
         axMfzMjEc7Cnemv54hNJtEM2IhdI+1ev3f4755+YRqXZqFgdSAJ8hZIqLpeUpZ/z00GL
         VNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EcBNTwy79MX3yH1H5a4QAnADWJ5Ti4Rl/SXJla0EyZ4=;
        b=nm/FzA9DUGWzfAzyW3YyE57Jw5tdGXhYqGFEp+MnOYUtLtErQE6kCwJX/eZ71+PXO4
         RLoOrgDv65MkjyFBmJN7NLVAYeAlTyybCUXMcSrhtVuNrHuRE5e1yBv6k6x85TFZl3cJ
         yvSGMhanwcVe9HyBxGZvYdAXsTMLHm4n3dqNg+ZaME1KRlgjISdO0nw2DbeiwlkgJdWE
         8EscitXDpvAweBowO0VfBfNohCOzozJ8GbEtXc1wm9Iwme/RN1QRLqkhTW0k16tAXgL9
         eRBpbbJwxNi+H62RdB6Xw8o+3wzgGxZftu7Zfn1DH3yqrudF+NX8FLEX+kQJW/RD3391
         mKJg==
X-Gm-Message-State: AOAM530IrHNRNp4swnU+bHb9F+sEuAgPGciNwyMVEeLQYjQvBY/etoR4
        Me+jQKorp7C4q+JmOa0dqbtyfA==
X-Google-Smtp-Source: ABdhPJx/pPxw53uxkq/nACPPwgXrmklmvJLs476FN9UQPOs4ivnqS7VxKZiRHA/3M8deVkMGW7Fcqw==
X-Received: by 2002:a2e:3202:: with SMTP id y2mr1622059ljy.155.1590530662543;
        Tue, 26 May 2020 15:04:22 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id 1sm269029lft.95.2020.05.26.15.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 15:04:21 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 9594410230F; Wed, 27 May 2020 01:04:23 +0300 (+03)
Date:   Wed, 27 May 2020 01:04:23 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 07/16] KVM: mm: Introduce VM_KVM_PROTECTED
Message-ID: <20200526220423.7gkyam4tp67gdvp5@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-8-kirill.shutemov@linux.intel.com>
 <29a1d089-ab37-321c-0a01-11801a16a742@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29a1d089-ab37-321c-0a01-11801a16a742@nvidia.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 11:40:01PM -0700, John Hubbard wrote:
> On 2020-05-22 05:52, Kirill A. Shutemov wrote:
> ...
> > @@ -2773,6 +2780,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
> >   #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
> >   #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
> >   #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
> > +#define FOLL_KVM	0x80000 /* access to VM_KVM_PROTECTED VMAs */
> 
> I grabbed 0x80000 already, for FOLL_FAST_ONLY. :)

Let's see who getting upstream first :P (Spoiler: you)

-- 
 Kirill A. Shutemov
