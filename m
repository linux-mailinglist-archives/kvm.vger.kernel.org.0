Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFFAAB087
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 04:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391109AbfIFCMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 22:12:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16927 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbfIFCMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 22:12:24 -0400
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1CAEE81F22
        for <kvm@vger.kernel.org>; Fri,  6 Sep 2019 02:12:24 +0000 (UTC)
Received: by mail-pl1-f198.google.com with SMTP id v22so2620031ply.19
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 19:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4+KRqgnMyWTJLeEvyGcJg55Gu2c2sD0q/0wWLjB74gM=;
        b=nMActTxiT6AL9b3Yhr6YM7CNVTTNFkLvJpbV7wVMAZg3bgedkLA70e3Ijv3H23AedD
         b9+WOtsd23H+fZ5iGihgdrIPB34hWOuAjWIa1ZnodR/v2gZEWjgejX466b7ksk/j0muo
         0ufyhlBQdP28IL42XGOcd/G0n+vimHVMouliG47oFTXkCoA+JbKXhgPxd+LDbCmXzoLW
         T/CFAE7hzruW/2I9ysxOf+sCGe3pVlsrK23GOZ/vnzXa6QMyP1s3ZRmAWG5GcjJEMJCn
         7LaqW6zAEj8bqWW4nGD+6oXYgL7P0FxCJewh0pqn7BFyEkcZx2aD8e8kat1IXF2tkX8S
         LasQ==
X-Gm-Message-State: APjAAAUqPddk3iFdNiZj8FaZZUd27F0KKjBpCO9hXIDLB5nj7YF0mCWS
        Et4C0PK6w6W3ktu5wa2cRm1v4rmvsJlAh06zZRTVD64+nWAnJkojuAVqyPrq7epnprXGTwWwBQy
        ZS7nQQLMmWJcx
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr6548263plq.316.1567735943667;
        Thu, 05 Sep 2019 19:12:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw+wV1cRvk7aHfxCCtDNaVlygGcT48TrKBmE+UDjiPNzq/x8IGW5zpov+5Q43i/2E8YHGSv2g==
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr6548243plq.316.1567735943382;
        Thu, 05 Sep 2019 19:12:23 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x22sm6613698pfo.180.2019.09.05.19.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 19:12:22 -0700 (PDT)
Date:   Fri, 6 Sep 2019 10:12:13 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v3 4/4] KVM: VMX: Change ple_window type to unsigned int
Message-ID: <20190906021213.GB10917@xz-x1>
References: <20190905023616.29082-1-peterx@redhat.com>
 <20190905023616.29082-5-peterx@redhat.com>
 <20190905155823.GB29019@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190905155823.GB29019@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 05, 2019 at 08:58:23AM -0700, Sean Christopherson wrote:
> On Thu, Sep 05, 2019 at 10:36:16AM +0800, Peter Xu wrote:
> > The VMX ple_window is 32 bits wide, so logically it can overflow with
> > an int.  The module parameter is declared as unsigned int which is
> > good, however the dynamic variable is not.  Switching all the
> > ple_window references to use unsigned int.
> > 
> > The tracepoint changes will also affect SVM, but SVM is using an even
> > smaller width (16 bits) so it's always fine.
> > 
> > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/x86/kvm/trace.h   | 8 ++++----
> >  arch/x86/kvm/vmx/vmx.c | 4 ++--
> >  arch/x86/kvm/vmx/vmx.h | 2 +-
> >  3 files changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index f1177e03768f..ae924566c401 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -891,13 +891,13 @@ TRACE_EVENT(kvm_pml_full,
> >  );
> >  
> >  TRACE_EVENT(kvm_ple_window_update,
> > -	TP_PROTO(unsigned int vcpu_id, int new, int old),
> > +	TP_PROTO(unsigned int vcpu_id, unsigned int new, unsigned int old),
> >  	TP_ARGS(vcpu_id, new, old),
> >  
> >  	TP_STRUCT__entry(
> >  		__field(        unsigned int,   vcpu_id         )
> > -		__field(                 int,       new         )
> > -		__field(                 int,       old         )
> > +		__field(        unsigned int,       new         )
> > +		__field(        unsigned int,       old         )
> 
> Changing the trace event storage needs to be done in patch 3/4, otherwise
> we're knowingly introducing a bug (for one commit).  Alternatively, swap
> the order of the patches.

I'll swap.  Thanks,

-- 
Peter Xu
