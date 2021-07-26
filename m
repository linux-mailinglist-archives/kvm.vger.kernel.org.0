Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962133D6968
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 00:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhGZVlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 17:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbhGZVlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 17:41:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22581C061760
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 15:21:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i10so10325169pla.3
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 15:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3ODcicexHURy+S/oaAgcJ5/PC6scXaOeWpaZLuQrIGg=;
        b=IAzkdNqPCe3UCa/Ivef3h6QOhsZcQ4xoUEUHk8FeitquYy68VmMEBlXDZhPoyNW2wC
         WKPCGzyk2t55n2cRxI7CvdMQCOrxKVTnx2le8z0LIAYPSdKQiqbyMjNijMulDmTM3+Hy
         aVhddjr1X9gKKoBMcPjGBdkbxYVs3s9ZIlRt2jI5yew+ENV1wzHYblng9navUwxi3w0s
         MnMXl6vr0Ja+qPp7HxIW7e99dDDWl2FYv8lHi4OK0KwPl8+9ZJAE4o1XMw1B+dG7a0W+
         bpAK73jUPDg8BqYnadcxMCmztL/T8dMw6BvIkzlDxUQigUtolFwEZHvzzwZqPMdEcrlR
         hhWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3ODcicexHURy+S/oaAgcJ5/PC6scXaOeWpaZLuQrIGg=;
        b=fdUJQ9oWodJnkwtazHdwv03zXPI89Ze0yUbb0YrRzXA88usakcdu5uNTFG6LG7IfDb
         gfAwubMQ/tmUg/pnB2cfkazA/lR6JEiMeg25Z7rsPk6i/ckBrbHjosFJveT+S/idy9aj
         v5TO0eAnZ6mGZ1iF3IvgXzYLamSFERb+80qj+VJmznSCsWBs4i6HtYLx/EV2r91x7g0j
         J/YViCutM5+oshk3rRrijv2//vEQKPC+So6YbzuB3N8rST+2YWWRA+mqqZ7G/W/64bDS
         8Pp/i53YiX6eZy2Zd+N0lMVFzaDLg3N3CXLhoEKAytqBIqa4Egrd81fCGQtSvbSe52ZL
         1E2w==
X-Gm-Message-State: AOAM531x7ep9F5GMz5XXAb5tdkyktdk6+je7WUtEpvSuFQNFbJF9i5ke
        zm4EhOEghTslFtjt21k2X2ksiQ==
X-Google-Smtp-Source: ABdhPJyHjwnafAVBd3m1vItXPruoOWhlMHo9hLIAry+D18DIh0irNV1yEz7PtzB5CxwsQZzRhQJwjw==
X-Received: by 2002:a63:2355:: with SMTP id u21mr2182989pgm.94.1627338107450;
        Mon, 26 Jul 2021 15:21:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g20sm1051906pfj.69.2021.07.26.15.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 15:21:46 -0700 (PDT)
Date:   Mon, 26 Jul 2021 22:21:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 41/46] KVM: VMX: Smush x2APIC MSR bitmap adjustments
 into single function
Message-ID: <YP81dzqaD//iNr5L@google.com>
References: <20210713163324.627647-1-seanjc@google.com>
 <20210713163324.627647-42-seanjc@google.com>
 <7ddb5bfb-f274-9867-3efb-0b6ba5224aa2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ddb5bfb-f274-9867-3efb-0b6ba5224aa2@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Paolo Bonzini wrote:
> On 13/07/21 18:33, Sean Christopherson wrote:
> > +	if (!(mode ^ vmx->x2apic_msr_bitmap_mode))
> > +		return;
> 
> Just !=, I guess?

Ha, yeah.  Forgot to do a bit of critical thinking after refactoring.
