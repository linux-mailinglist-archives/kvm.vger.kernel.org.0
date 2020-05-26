Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EA11E31B5
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 23:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389618AbgEZV40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 17:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389582AbgEZV4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 17:56:24 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625E3C061A0F
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 14:56:24 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id b6so26478015ljj.1
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 14:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KxA9UmGJJnl7Bb+4Hp5hGEl722cKfUNLx8ou3ZEhvTQ=;
        b=Rdj07d1EbBsd4yaGts4o+yqzcD6soXFmwEnvmWnKKkkMxr4IzXZCRjUTJqQ0b010v3
         QCViqtYyatK+6gpTvUUspFrQ+zruGqU7KH44vMYy2OZ3Zz/zaly4trhle/tcrtMgZMnm
         LnEITkjaw/mB9K1DttC+YgzADHQ/izR/asILurcN7rLch/r/ZUjle2DQa17WJYFuL7H9
         yfWZ+EOFZPbQkSb/D/+GXzEViwlKYd4HKr0NRPce3hroQ0JffQtCKP79tgSShlUSHbm7
         UkQQ0zKl4bK/mvTBH0UJYqgNftgHENuCLJzhnIk6dqfK20eYm7k60qJVlizWE2dv5ebi
         QR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KxA9UmGJJnl7Bb+4Hp5hGEl722cKfUNLx8ou3ZEhvTQ=;
        b=J+yC9mhbbs9pJRbt1tsr4m6i6C6kCI1mpbkszqLgiUGWd17QsqzmWgGA16OwEi9LCR
         QVtlLJdCCE+NkN3GMZAAwsYc/4MT2MImnn1xL7nv9ozobrr3tHi5/BqyfaKChfeRMd8d
         akMjkhawLMwk6V1lVM2TMWS1OYGY716IQll/WX3WiLhILlhNIJUVlOBfQYyr1aOKDgqH
         QsBQlEz+XaDRaf8UQ53tV5f2/1lTDb13fBuC5ydbU0A8KcDzeMbRaOVvYhtlshmHGzPX
         sUFbj2eNw0xO7gFEx9HBzZzijwVeHgcDZKTzXx3qK9fRCVQNX1c8X2Mc8Ne9lwl8xg4g
         63Sg==
X-Gm-Message-State: AOAM533F4CBdpHS8PMXeO3SeMphsYQLAhJWrfb7pZlLc0oOIlxnQSyz2
        mcYy2dhm0vPd85GOTRocq2Rtng==
X-Google-Smtp-Source: ABdhPJyBJffVuN8Gxouh7odL35w4h73NN8hmaj17eT0JxNv7QR2g36h9/tqS3jaVBhyIz8dNFQkR1g==
X-Received: by 2002:a2e:8091:: with SMTP id i17mr1625888ljg.141.1590530182839;
        Tue, 26 May 2020 14:56:22 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id w24sm218345ljo.136.2020.05.26.14.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 14:56:22 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 850B710230F; Wed, 27 May 2020 00:56:22 +0300 (+03)
Date:   Wed, 27 May 2020 00:56:22 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Mike Rapoport <rppt@kernel.org>
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
Subject: Re: [RFC 06/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20200526215622.r455gfohtufr45vj@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-7-kirill.shutemov@linux.intel.com>
 <20200526061459.GC13247@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526061459.GC13247@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 09:14:59AM +0300, Mike Rapoport wrote:
> On Fri, May 22, 2020 at 03:52:04PM +0300, Kirill A. Shutemov wrote:
> > New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
> > protection feature is enabled.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  include/linux/kvm_host.h |  4 +++
> >  virt/kvm/kvm_main.c      | 78 ++++++++++++++++++++++++++++++++++------
> >  2 files changed, 72 insertions(+), 10 deletions(-)
> > 
> >  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> > -				 void *data, int offset, int len)
> > +				 void *data, int offset, int len,
> > +				 bool protected)
> >  {
> >  	int r;
> >  	unsigned long addr;
> > @@ -2257,7 +2297,10 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> >  	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
> >  	if (kvm_is_error_hva(addr))
> >  		return -EFAULT;
> > -	r = __copy_from_user(data, (void __user *)addr + offset, len);
> > +	if (protected)
> > +		r = copy_from_guest(data, addr + offset, len);
> > +	else
> > +		r = __copy_from_user(data, (void __user *)addr + offset, len);
> 
> Maybe always use copy_{from,to}_guest() and move the 'if (protected)'
> there?
> If kvm is added to memory slot, it cab be the passed to copy_{to,from}_guest.

Right, Vitaly has pointed me to this already.

-- 
 Kirill A. Shutemov
