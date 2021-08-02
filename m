Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2CC3DDDC4
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhHBQez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhHBQey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:34:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2854FC06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:34:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u2so11989915plg.10
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bi/McSu5rgZjmipTgVgtwGrGIXFV7d2s60lhYfXtq4A=;
        b=PzbR0unERo1CF0c0AfA9crVsGVDdY3Wo/wAR64t4ZgUg+sOWeA2pgEw02YuXGvquD9
         1bHZS+HAf4fKXaUtlyWup+ZoP2BHo3ZRGjjZfKmcZqkn37ZuRjh2VarLUNTSHdlseUWU
         phDkzz2Wx1/tBKAQptRd2gOrR+yGCgSf/vg+ShtMKU8kSDIDS4+jUa3kw5R5UH81q1gT
         CfgoCGug+Ru9HkRUw76YjqQ+D/Pp27KK6TNELnH6rN/m0e6PUA0ns7gtykL+1ffJAH3Y
         +ZECiy3IUrlsxVFXypQfbHQiaYIsgTFKDEVtkpXFvxA976kztsZUSBt8wmnTEvwmDai6
         hIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bi/McSu5rgZjmipTgVgtwGrGIXFV7d2s60lhYfXtq4A=;
        b=TCA/uRkM+UAvulGPF0V6uUzie/CSVx5drzU+WoWkmNTgB/AGodtgtNSsV+1w0k/dtn
         36SPLqoK7CMyirqjdqvBfx6KP0th6U04lPjfXHVYTh7bu8OQec6MkHMxuwa6T3VuuEW+
         vZc6TFQWAPsur6V030xL9jevaIDPn74Ip0D8leydSzYbg9d99uwh6rKzc5G072+VRIr/
         9/TE4A7kSTNNI7vYfMAHiFxEEC48Sr/se5hQzpUkZUw2zpHanEZJKZdU0Gy1RxJlIIbw
         LI3oiiuKa16PEZvPYRgWR5z6Vr5bStFS7XJSQE1I7PGKHnGjbDZ29g5/u1JkKDnjB5VL
         MzXQ==
X-Gm-Message-State: AOAM531xi9qp+6HyfBGSg4TRoga9mYfFuuMVlMOvEpegw4gmKH4Fm7Lt
        LX4NbYj7nRUCfcrP9hMVJBEwBw==
X-Google-Smtp-Source: ABdhPJwkfRTKlBoRj36phE//kPga1bZX9wIU7av/sKd7AR0P7bD8iviOqI60Ppq2BrFYETKIbdO8WQ==
X-Received: by 2002:aa7:90c8:0:b029:32c:935f:de5f with SMTP id k8-20020aa790c80000b029032c935fde5fmr17660349pfk.79.1627922084544;
        Mon, 02 Aug 2021 09:34:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l11sm13097806pfd.187.2021.08.02.09.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:34:44 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:34:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org,
        jmattson@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit}
 tracepoints
Message-ID: <YQgeoOpaHGBDW49Z@google.com>
References: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
 <20210621204345.124480-2-krish.sadhukhan@oracle.com>
 <ac5d0cb7-9955-0482-33ee-cf06bb55db7a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac5d0cb7-9955-0482-33ee-cf06bb55db7a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021, Paolo Bonzini wrote:
> On 21/06/21 22:43, Krish Sadhukhan wrote:
> > With this patch KVM entry and exit tracepoints will
> > show "guest_mode = 0" if it is a guest and "guest_mode = 1" if it is a
> > nested guest.
> 
> What about adding a "(nested)" suffix for L2, and nothing for L1?

That'd work too, though it would be nice to get vmcx12 printed as well so that
it would be possible to determine which L2 is running without having to cross-
reference other tracepoints.
