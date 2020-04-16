Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF7F1ACD8F
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405108AbgDPQW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 12:22:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35329 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391207AbgDPQW4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 12:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587054175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z/zwjhrI8gOJNaE/NYGSbfbUc4Dee0aRBTzvNwecMd0=;
        b=hPFH47csh0ms+WSJAUzuhOF0Hb9/EZvLQYsOSFNpL+w3NDIKNhWs8NlhzkB46RGj8cwnvF
        uf2TUKvUtOPAUkSoUcqMP1jCn4epWin2zie14dda8PBbmxs42UvFRO7dMpiaWGfiSJot83
        RB8WD4HskLZ/dEHs++1XMWr4HalYvKc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-YYYYcPQ3OCuhKjW5SqW13Q-1; Thu, 16 Apr 2020 12:22:20 -0400
X-MC-Unique: YYYYcPQ3OCuhKjW5SqW13Q-1
Received: by mail-qk1-f200.google.com with SMTP id c140so12614655qkg.23
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 09:22:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z/zwjhrI8gOJNaE/NYGSbfbUc4Dee0aRBTzvNwecMd0=;
        b=JS/7n7uw2iVPj6bYpEKcrkH7+Yp55Lu6iJ05Pe13CfxQt7ir5vMeVOIcYaQm7LqzAx
         Phcs5k2dy6U+ybK6w6HSWxDP4iRqkoDrOZQnWkb5F0mFoUV0SmuKRuBb6HSywiB+rmmJ
         7HZnvedIFKBBtCJF+k1Xy3XqvSlZIb6i4LVy4jqlUk/7PC3e0ciVBggc/BRsXEV7NW5Z
         JIDR/sTCEmHooVv3Y068p7vySsD4pGi17E8FB27261qpsjiGhRntYan3GFzIh/Gns1fF
         tsLHe7+vbGkRRmL/eEiYiob9e8pOLgvGI7GcgeVQMEVbLoSEawEmVtNtoQxkxT89V7gH
         wXYA==
X-Gm-Message-State: AGi0PuZpbyOBJ0FavMAInCkfqO6bFJPDNqIFK5+ZIE8GWZufGWMvmFaC
        1L2sbrUhDNL590Uc0du7G2CvdemV8D4xU9LayxQYCgP7+STKDFoGxUB7bsw1Ib9iYmtsatIt09W
        GMxoX/lR0Uysl
X-Received: by 2002:aed:3e87:: with SMTP id n7mr27561851qtf.301.1587054140215;
        Thu, 16 Apr 2020 09:22:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypIPMiro0h10rxj0j2imuvI0+ZKP7HtXXHVSZBl44AM/Z0X/qX8yFv2iOjDvRGD2EaXyWoGsBQ==
X-Received: by 2002:aed:3e87:: with SMTP id n7mr27561825qtf.301.1587054139962;
        Thu, 16 Apr 2020 09:22:19 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id n63sm15209798qka.80.2020.04.16.09.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:22:19 -0700 (PDT)
Date:   Thu, 16 Apr 2020 12:22:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM: Remove async parameter for hva_to_pfn_remapped()
Message-ID: <20200416162217.GA267834@xz-x1>
References: <20200416155903.267414-1-peterx@redhat.com>
 <7f576843-6b64-6561-05ee-730326249409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7f576843-6b64-6561-05ee-730326249409@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 06:13:57PM +0200, Paolo Bonzini wrote:
> On 16/04/20 17:59, Peter Xu wrote:
> > We always do synchronous fault in for those pages.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> > 
> > Or, does it make sense to allow async pf for PFNMAP|IO too?  I just
> > didn't figure out why not...
> > ---
> 
> I think async pf would use FAULT_FLAG_ALLOW_RETRY |
> FAULT_FLAG_RETRY_NOWAIT.  On failure you would set *async = true.
> 
> In practice I don't think fixup_user_fault is likely to do anything
> asynchronously.

Yeah, I'm thinking whether the fixup_user_fault() could need time to
finish sometimes (IIUC that's major for the GPU drivers? I have no
idea, e.g., how long time it'll take normally for a major fault), then
whether we can also do that in another thread like what we do with
normal anonymous pages when it was swapped out.

Thanks,

-- 
Peter Xu

