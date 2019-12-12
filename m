Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF5411CB13
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 11:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfLLKiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 05:38:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28966 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728776AbfLLKiK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 05:38:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576147089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CGdrhhHyRlkbfocg8i54ButT9u7PpOFWc5l6oudrYoY=;
        b=HTm8ausO0z/fCAFnUJ2o7oNaCen64eOavswJLHN/qHUr8/Br4Ici/U+qFQlFqRXtZoRgS6
        FqhakvJsxXohehzaHwugmo+gwu+tjf/FZdnE8VfUjP0zrZx+rW4uRVlSTeM72MdVGUjKO/
        wALxyW/7fiDtcltD3R5MJrV1ETWxnx0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-D0W_PpgYO3KxdvdH4O0ENg-1; Thu, 12 Dec 2019 05:38:08 -0500
X-MC-Unique: D0W_PpgYO3KxdvdH4O0ENg-1
Received: by mail-qk1-f197.google.com with SMTP id j16so986373qkk.17
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 02:38:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CGdrhhHyRlkbfocg8i54ButT9u7PpOFWc5l6oudrYoY=;
        b=tjUAp/Y5H/RpQk1FhQlFAT5DIOL9VzgBJeur/omy1OKC4eCb4u+SV1o8mjBgGM+T4m
         /5WtuloEKrAhUUi6awvWqJ95PXkaH6+pu9kG2h49PPKvS4GflezlGFBjSm6Zk4hOvaRS
         P1EfyrhBiOC7qky7PV1iZhIJOYhFxBZzNUiLs7s3mz+oC31WUWP2fvU2zkOFbQLaHI1B
         /yrjaCW33+0sHiOJUbEl+CT2+12rWHEman6Kmk9m0Puy8DmsdB0EZJYK/oDmPpssl9YU
         WO0NoRwHOzO2WUlAiK3f7UoR6wQtauPrB4+1ZheumsAA7yPiQvsPr6VitM0OMYud4ql+
         8puQ==
X-Gm-Message-State: APjAAAVWuV6mvhhk8WkYgAclFDbSq6SYE+QcWB/m/+ANzmYw4eBBWAz4
        DAQkU121F2Zu5Pwe8ikz0dpufC13RANvUDw2DQn2FjXOEXodz5Bnkwa6oGtQqqhQvFPmb1MVRKM
        onwpnxQAkxEli
X-Received: by 2002:ac8:31f0:: with SMTP id i45mr6826435qte.327.1576147087652;
        Thu, 12 Dec 2019 02:38:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqy533LAorMnek81fxEnELYfHSOMJtzaFsHpey7OtVFs0ONCSNjDRC58Vp1XiF2XTw+x7brejg==
X-Received: by 2002:ac8:31f0:: with SMTP id i45mr6826421qte.327.1576147087458;
        Thu, 12 Dec 2019 02:38:07 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id 53sm2085127qtu.40.2019.12.12.02.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 02:38:06 -0800 (PST)
Date:   Thu, 12 Dec 2019 05:38:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191212053403-mutt-send-email-mst@kernel.org>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org>
 <20191211205952.GA5091@xz-x1>
 <20191211172713-mutt-send-email-mst@kernel.org>
 <46ceb88c-0ddd-0d9a-7128-3aa5a7d9d233@redhat.com>
 <20191212023154-mutt-send-email-mst@kernel.org>
 <74edef57-c1c7-53cb-4b93-291d9f816688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74edef57-c1c7-53cb-4b93-291d9f816688@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 09:12:04AM +0100, Paolo Bonzini wrote:
> On 12/12/19 08:36, Michael S. Tsirkin wrote:
> > On Thu, Dec 12, 2019 at 01:08:14AM +0100, Paolo Bonzini wrote:
> >>>> I'd say it won't be a big issue on locking 1/2M of host mem for a
> >>>> vm...
> >>>> Also note that if dirty ring is enabled, I plan to evaporate the
> >>>> dirty_bitmap in the next post. The old kvm->dirty_bitmap takes
> >>>> $GUEST_MEM/32K*2 mem.  E.g., for 64G guest it's 64G/32K*2=4M.  If with
> >>>> dirty ring of 8 vcpus, that could be 64K*8=0.5M, which could be even
> >>>> less memory used.
> >>>
> >>> Right - I think Avi described the bitmap in kernel memory as one of
> >>> design mistakes. Why repeat that with the new design?
> >>
> >> Do you have a source for that?
> > 
> > Nope, it was a private talk.
> > 
> >> At least the dirty bitmap has to be
> >> accessed from atomic context so it seems unlikely that it can be moved
> >> to user memory.
> > 
> > Why is that? We could surely do it from VCPU context?
> 
> Spinlock is taken.

Right, that's an implementation detail though isn't it?

> >> The dirty ring could use user memory indeed, but it would be much harder
> >> to set up (multiple ioctls for each ring?  what to do if userspace
> >> forgets one? etc.).
> > 
> > Why multiple ioctls? If you do like virtio packed ring you just need the
> > base and the size.
> 
> You have multiple rings, so multiple invocations of one ioctl.
> 
> Paolo

Oh. So when you said "multiple ioctls for each ring" - I guess you
meant: "multiple ioctls - one for each ring"?

And it's true, but then it allows supporting things like resize in a
clean way without any effort in the kernel. You get a new ring address -
you switch to that one.

-- 
MST

