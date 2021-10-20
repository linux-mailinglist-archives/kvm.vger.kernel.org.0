Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09B443534E
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhJTS75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhJTS74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:59:56 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC797C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:57:41 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s61-20020a17090a69c300b0019f663cfcd1so1249970pjj.1
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 11:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TvksdfctQPSKuZzYeC/pvdNqR1BvFx3obB1YwqOqH0c=;
        b=UUCVwojQK6iOOMJ0L1siU++CuwXPjXWsrIJs2r8AaeLfe5opibSmFTqvoavMS9rDIP
         MLgua2jERLSwvJHLmz/4DCAEi6VZ4Nk6uM8G9N0BoeXvtDKkWAOvF8jRixeiNPmBbijK
         54ppKEbGr59EOTlkQOomxerFYpsvlGPa7EuTbwB77MLCzUQYv6rzT4h9SMDhQCgRQxZu
         ehNTRQ3W+Irl1KPVGY6xGx/t3IyURScB85UCGBLsfqijfdv55+Hgi88A8UQu4I3QCnJl
         RuS4xxFjfTQcXhSkr4KnMKYMqVONQL7xfb2bF8Dp3/g+waBimrpjrjUfi4LTg7CYdoUq
         ZwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TvksdfctQPSKuZzYeC/pvdNqR1BvFx3obB1YwqOqH0c=;
        b=joojES9vVfcsTm75hKsrQxcvIyudtJ/WTiEZxAhh+pD1jCTsJECsKoni5LeVIEcyJ2
         fwjXe9s2MwsKkoMdGBrfuUNDNZrkVMKwoqMpE1ImiK1h14ei79Dsedzi3ULYf4c29Kdl
         rS6TdOZYDm29fH9UvENxAqcfst8qWwixwHFD19bzdesO3BrtbKTHMHYpjLYi14FS+iYK
         GBJF/u0RKKvY/ehi8kSWywKj3/AjsISOlZ+/5lM7mGLGApUS4gj+K4fvamh+VTk4+Si/
         0O3d2v4/71ljPWBE5uhDHIRcM7mC3b6cX4XOG+ckY+UlEqHL9W1aPvD1r3nOu9HbWzPh
         EqbQ==
X-Gm-Message-State: AOAM531ZMpWzVHWMgiYPMFHD6+vwLetwU3kTASpy3EXPbdbawJm1FHPp
        jDFCfec5ulu0RHLKweJy1xpiDA==
X-Google-Smtp-Source: ABdhPJzDLaX0rT8jygcwV00K+SrPUQVwuAiJXVjXGIOFpcsdXoxMZABmhV6zUYF3vlOIU9g+BFBTnA==
X-Received: by 2002:a17:902:be0f:b0:13a:95e:a51 with SMTP id r15-20020a170902be0f00b0013a095e0a51mr827571pls.44.1634756261166;
        Wed, 20 Oct 2021 11:57:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z8sm3105052pgi.45.2021.10.20.11.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 11:57:40 -0700 (PDT)
Date:   Wed, 20 Oct 2021 18:57:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/13] KVM: Just resync arch fields when
 slots_arch_lock gets reacquired
Message-ID: <YXBmoP4Lf2o1OiHY@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <311810ebd1111bed50d931d424297384171afc36.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9a2s8wHXzf8Xqw@google.com>
 <b9ffb6cf-d59b-3bb5-a9b0-71e32c81135a@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9ffb6cf-d59b-3bb5-a9b0-71e32c81135a@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Maciej S. Szmigiero wrote:
> On 20.10.2021 01:55, Sean Christopherson wrote:
> > On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> > This should probably be a memcpy(), I don't know what all shenanigans the compiler
> > can throw at us if it gets to copy a struct by value.
> 
> Normally, copy-assignment of a struct is a safe operation (this is purely
> an internal kernel struct, so there are no worries about padding leakage
> to the userspace), but can replace this with a memcpy().

I was more worried about the compiler using SIMD instructions.  I assume the kernel
build process has lots of guards in place to prevent such shenanigans, but on the
other hand I _know_ mempcy() is safe :-)
