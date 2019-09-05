Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0EA9842
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 04:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfIECP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 22:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727544AbfIECP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 22:15:27 -0400
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 276653CA11
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 02:15:27 +0000 (UTC)
Received: by mail-pl1-f198.google.com with SMTP id j9so510295plt.18
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 19:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/wGnUBIR2mfWMs6dphZaf2dS32/dT6Xx2bsTzrR2AR4=;
        b=qCIINuCD32kMXg5NcoeL6W9HvYbF5LMbsd++Dp3Gawwx8mQrh5Ghoj2LcDX3bkxUwX
         Q9DjCkzhzsPtQOqK5AV2oRXEQp/V4qGNWvHwEmFQ7PoP73E/puOpuvyK5Nhc/5i32Oo1
         GpKZ6tLCWYrD7tUyq8SDw8VH3kLn5Ns1vU909IZtCzmHryhzT+lnP9CqEudekjy7OssP
         jf23cKrs8tMNlC0O3GT64hdjGgzuCXosPDMALMwYgAj2Rgp8/d8Bd4LL5Tmrv124fSPs
         FkVBqfIwjPMtz0H6ReIv3rjD3gdB5rbaXFGMJu/JGpp8hAizVhqnjGfozWMyqXEhaXMK
         rQoQ==
X-Gm-Message-State: APjAAAXGBAuT+Q31HjWc9LSIvNgv89Z0Rxfr89WyLAxRPXxDH6PlmNxj
        fthOhGlk4zOgXo4HveNTk/fNvsOuKRQhiPnqS+AVV+pchHfo9AmLhFRU8AWnc96y5z0Dnm7cIrI
        KMOfsn+pY6pDd
X-Received: by 2002:a17:902:8644:: with SMTP id y4mr842189plt.333.1567649726484;
        Wed, 04 Sep 2019 19:15:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwM07DnJUteMkxqTS3RpeAzLhEU6/t3VAcuUfhRGhUxn4lk1ZnSL8ha9Iwapy5RvByV9K8edg==
X-Received: by 2002:a17:902:8644:: with SMTP id y4mr842175plt.333.1567649726297;
        Wed, 04 Sep 2019 19:15:26 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i1sm415740pfg.2.2019.09.04.19.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 19:15:25 -0700 (PDT)
Date:   Thu, 5 Sep 2019 10:15:15 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v2 1/3] KVM: X86: Trace vcpu_id for vmexit
Message-ID: <20190905021515.GD31707@xz-x1>
References: <20190815103458.23207-1-peterx@redhat.com>
 <20190815103458.23207-2-peterx@redhat.com>
 <20190904172658.GH24079@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190904172658.GH24079@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 10:26:58AM -0700, Sean Christopherson wrote:
> On Thu, Aug 15, 2019 at 06:34:56PM +0800, Peter Xu wrote:
> > Tracing the ID helps to pair vmenters and vmexits for guests with
> > multiple vCPUs.
> > 
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  arch/x86/kvm/trace.h | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index b5c831e79094..c682f3f7f998 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -232,17 +232,20 @@ TRACE_EVENT(kvm_exit,
> >  		__field(	u32,	        isa             )
> >  		__field(	u64,	        info1           )
> >  		__field(	u64,	        info2           )
> > +		__field(	int,	        vcpu_id         )
> 
> It doesn't actually affect anything, but vcpu_id is stored and printed as
> an 'unsigned int' everywhere else in the trace code.  Stylistically I like
> that approach even though struct kvm_vcpu holds it as a signed int.

True.  I can switch to unsigned int to get aligned with the rest if
there's other comment to address.  Though from codebase-wise I would
even prefer signed because it gives us a chance to set an invalid vcpu
id (-1) where necessary, or notice something severly wrong when <-1.
After all it should far cover our usage (IIUC max vcpu id should be
512 cross archs).

Thanks,

-- 
Peter Xu
