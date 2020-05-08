Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A3A1CA0DB
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 04:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgEHCZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 22:25:24 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26763 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726542AbgEHCZY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 22:25:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588904722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgMFR9cyTTMixO1Ql+95+NA7pVO6Q1XyLD5vZbD5wHE=;
        b=HQle3m75FAhyWzachq9DKykRieDa2H41l4p8rGzFqfwZowSEUeW3sI77sTNqgGfbLwsZ9N
        sS2odF12lHWZgnYzOOGoWyr7wlHLtJkT6c2xUbAWOVyos7bqUzp/OZs3JJZMa4d9U0210U
        oQNWJg+kxZTqMXhg3pyG/2UPO5sy4mI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-30xnG1qdN9e84-YO1OL19w-1; Thu, 07 May 2020 22:25:20 -0400
X-MC-Unique: 30xnG1qdN9e84-YO1OL19w-1
Received: by mail-qv1-f72.google.com with SMTP id b13so261137qvk.5
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 19:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HgMFR9cyTTMixO1Ql+95+NA7pVO6Q1XyLD5vZbD5wHE=;
        b=kygrv2YGp3Q25wJxy25ocYBUPzPRTWnvQqi0uPUTgljm29jV2EVfOlj2bRbzvmaaUn
         WndpfrlNkHdU57/8dxZ15nPaCJYM1aUb+bwvKqhv22ASapb3Fd9B6CQnOzE/1Az3/6I1
         LrwspHnqxeT1FaAlTjuAtct1y3XTVWGoGA+uev9evietKJ9YfDfQJpT4ds4a9ijbRaZB
         zOhWmS6uLSEfgrJllmE6HHljkAM2GKLyBIM13p3o85gC5MkslVvqcWA5E+d1RTQ5VLUu
         Ufi3lK6R59BGkoI2onG+pDv8tlAqYSA2+KfE0jYk0eEfmcNEj0l5B/5RoYgcBZlnjvN6
         WW8g==
X-Gm-Message-State: AGi0PuZqczwLobx9H/xH2hl73SsltBtfhICN23ZiaRySy51b76O8LrPp
        81m27jdHTdDzxSjw7KmYM5zzXuFHxoFHGcoZx0TnSMg7p8Q/Cl3EQrtfn3S61kNPCtgffGVkUNx
        iTzNCig/51fY0
X-Received: by 2002:a37:a0d5:: with SMTP id j204mr516573qke.128.1588904718415;
        Thu, 07 May 2020 19:25:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypIKX0R7e23p4PaPAxpllFX4wuiHajFXXSUjlXexRj4Cn/r8DZm4DuzhqLHB7D2eJE6vTqLgdg==
X-Received: by 2002:a37:a0d5:: with SMTP id j204mr516497qke.128.1588904716602;
        Thu, 07 May 2020 19:25:16 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id x124sm174293qkd.32.2020.05.07.19.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 19:25:15 -0700 (PDT)
Date:   Thu, 7 May 2020 22:25:14 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM: No need to retry for hva_to_pfn_remapped()
Message-ID: <20200508022514.GU228260@xz-x1>
References: <20200416155906.267462-1-peterx@redhat.com>
 <dba4f310-5838-cd78-73c9-3db84f93766a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dba4f310-5838-cd78-73c9-3db84f93766a@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 06:59:30PM +0200, Paolo Bonzini wrote:
> On 16/04/20 17:59, Peter Xu wrote:
> > hva_to_pfn_remapped() calls fixup_user_fault(), which has already
> > handled the retry gracefully.  Even if "unlocked" is set to true, it
> > means that we've got a VM_FAULT_RETRY inside fixup_user_fault(),
> > however the page fault has already retried and we should have the pfn
> > set correctly.  No need to do that again.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  virt/kvm/kvm_main.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 2f1f2f56e93d..6aaed69641a5 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1824,8 +1824,6 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
> >  		r = fixup_user_fault(current, current->mm, addr,
> >  				     (write_fault ? FAULT_FLAG_WRITE : 0),
> >  				     &unlocked);
> > -		if (unlocked)
> > -			return -EAGAIN;
> >  		if (r)
> >  			return r;
> >  
> > @@ -1896,15 +1894,12 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
> >  		goto exit;
> >  	}
> >  
> > -retry:
> >  	vma = find_vma_intersection(current->mm, addr, addr + 1);
> >  
> >  	if (vma == NULL)
> >  		pfn = KVM_PFN_ERR_FAULT;
> >  	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> >  		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
> > -		if (r == -EAGAIN)
> > -			goto retry;
> >  		if (r < 0)
> >  			pfn = KVM_PFN_ERR_FAULT;
> >  	} else {
> > 
> 
> Queued, thanks.

Paolo, Is it still possible to unqueue this patch?  I overlooked the fact that
if unlocked==true then the vma pointer could be invalidated, so the 2nd
follow_pfn() is potentially racy.  Sorry for the trouble!

-- 
Peter Xu

