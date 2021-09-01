Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AF23FE431
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 22:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhIAUnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 16:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhIAUnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 16:43:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1345DC061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 13:42:50 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso619577pjb.3
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 13:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XOYbBcZfGzF/GFJTV2MKKMcwcKh9wXUYdzqh6PhHqo8=;
        b=Oxvthq/+mxrcIm2HiWo5aFVMaPc1i7CCOxzlLMoaF9YsaPNhXSL3IhNrPPWMTRwWFK
         DpcaWMRGPqA57Hwulv1Zz6nSpxOWGwTTaOc9I8ufT9wP315UAC25EX3hMQl98Fn+aisA
         xkW6pf4ipNU8sisq43vcT2p6VTsD3sps6vthb0FzT+Qhqz1mUSfC79j/GaupxDocnPVW
         uFPNBq85dfg3tQCU1xGYSguamOdYefxuQiVza6yW1Y3+j17T4vo8C4/0bLh7/WOaoNrQ
         c+l4O4Td3d6cSCQlQ7CcEH6uQYq1key/qXBaicP/HYAya9lCDHBXjGs96PWcSxtsUo6I
         AgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XOYbBcZfGzF/GFJTV2MKKMcwcKh9wXUYdzqh6PhHqo8=;
        b=q46/b4yIopzzz5zPInHx4TOYdSYk0VhQvQQ0YI12WS8+exJGDfaDw6FvNGFtXEiRUZ
         pBEsKIkGYn5JU4ZbK+Q3G7ymuLYOTE5QDoizhy7NZIsRrNZXERV9qKJQ+XkXvx84ZKIW
         qoGFd3ZQFgMPDbnbQaEaRMVkYj2bdB3tRGn/rSdljFM1HDSTlO4jJYoiCNxs3M8hW+GV
         4qtEsMRhG3HZfINfrSAa/uhWJ53NH7uyuI14eIKnCvYZ/mOuZ/aGreD2WqLU0o+uxveN
         g6VRvtOVMEmqRVuz2Fmw4ypYgHuJkjI2RWyOKf2ZCS/3URPPSRUikelIZyW+Ch4TY5WK
         Pz5Q==
X-Gm-Message-State: AOAM532cn6GJkUuuV7c2cx8PXc9RddeU91ebTf3af7n8DMk4KcJFGfG/
        mlghqDzivXwU0TVTPt09nhX/6Q==
X-Google-Smtp-Source: ABdhPJwky9qPSpAZBvisg7X/BuQEZZBcIOd3fsg6IXbVH4pEhc7/EyhBbeUP5F+2XBZMKfArlYzTXQ==
X-Received: by 2002:a17:903:234d:b0:138:96ac:66c4 with SMTP id c13-20020a170903234d00b0013896ac66c4mr1177712plh.18.1630528969328;
        Wed, 01 Sep 2021 13:42:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y8sm338653pfe.162.2021.09.01.13.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:42:48 -0700 (PDT)
Date:   Wed, 1 Sep 2021 20:42:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YS/lxNEKXLazkhc4@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
 <YRvbvqhz6sknDEWe@google.com>
 <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
 <YR2Tf9WPNEzrE7Xg@google.com>
 <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021, Robert Hoo wrote:
> On Wed, 2021-08-18 at 23:10 +0000, Sean Christopherson wrote:
> > > My this implementation: once VMX MSR's updated, the update needs to be
> > > passed to bitmap, this is 1 extra step comparing to aforementioned above.
> > > But, later, when query field existence, especially the those consulting
> > > vm{entry,exit}_ctrl, they usually would have to consult both MSRs if
> > > otherwise no bitmap, and we cannot guarantee if in the future there's no
> > > more complicated dependencies. If using bitmap, this consult is just
> > > 1-bit reading. If no bitmap, several MSR's read and compare happen.
> > 
> > Yes, but the bitmap is per-VM and likely may or may not be cache-hot for
> > back-to-back VMREAD/VMWRITE to different fields, whereas the shadow
> > controls are much more likely to reside somewhere in the caches.
> 
> Sorry I don't quite understand the "shadow controls" here. Do you mean
> shadow VMCS? what does field existence to do with shadow VMCS?

vmcs->controls_shadow.*

> emm, here you indeed remind me a questions: what if L1 VMREAD/VMWRITE a
> shadow field that doesn't exist?

Doesn't exist in hardware?  KVM will intercept the access by leaving the
corresponding bit set in the VMREAD/VMWRITE bitmaps.  This is handled by
init_vmcs_shadow_fields().  Note, KVM will still incorrectly emulate the access,
but on the plus side that means L2 will see consistent behavior regardless of
underlying hardware.
