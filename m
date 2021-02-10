Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F0C317224
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 22:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhBJVPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 16:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbhBJVNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 16:13:55 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16556C0613D6
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 13:13:15 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id t29so2105810pfg.11
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 13:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d2q16jUlTFF+PgCEeQltVe2F+f6bF9tkUCQkjupb9s0=;
        b=rPvutsHIjPqDhDGHVJxc/wM5v7CXDtz6AAMW3V7N0WFLbcXp6VlPvu2+MuYojMLpu6
         GIM+7Cy5mjsqo+ICRC7VnG2x51YmptvQXPyPrl7hhAwbs8+Syc01kUyEuKHQy2xODowj
         4uNefQtC8cqbHjMEd99RGKqCK9x0frcN2G1H2KCct+NI2QxkRqKoeblxVWK4wnmFXuH9
         lR34nHkyF7KBoxhgHidVyqe4QOqy6qH/76EIM3dmZdaepccL+TUKbvmHW94HM9zZrz3w
         Z/EcBwAAiQgkZmdkpX5PUz5rw4h75HtAtgIpd+/TF+5MespBcPmDjg1ipd6NASc1bmFv
         JWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d2q16jUlTFF+PgCEeQltVe2F+f6bF9tkUCQkjupb9s0=;
        b=aZdMl4P+XUwP66kLebQaxEyBeG+0jhuwcXq8txEfDSh5IzGLvEhuvMuwBWdZ+xHbXk
         ZOue8ehwY9YXn1BO8IRJ/2Tt15UhFCB8g5N5TcSwzqfrGsxK5mgHPH8ZDerDdo9w2dRB
         a/OF9O0JRFRkN/j5G8RsXwESENgsTzJtHquUONFBa+fZmuehLcNQAioEJEOWPOh0E/0P
         +rIH7bpVhmjv/3ag3Bnx5y5a3EmnuBVOGO/Sr06qttIn2pwGmyKB5kF9YZSdvxruey4c
         IY+cb4lNMUHUjPT6gmy0+d3jGhoO2kXIktMcWpbV8K7PMpIKako8tBNIeyl/sKcGIxDe
         cK2g==
X-Gm-Message-State: AOAM533Q9VonoDn2LXZ70P8MvqIDD0k6tZ3Q2tIJcBfJxb4XmQn0I2zc
        pd+sa93+wpi3fQfdIWWcbVTiWg==
X-Google-Smtp-Source: ABdhPJzCMbl2wASW0GAEU7dIZgfYB/lg8BCOSGP4JPjM9/s0k9fP4z8jGrPdqeSRqTlzzhtNgn5ZWw==
X-Received: by 2002:a63:5d59:: with SMTP id o25mr4757081pgm.322.1612991594307;
        Wed, 10 Feb 2021 13:13:14 -0800 (PST)
Received: from google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
        by smtp.gmail.com with ESMTPSA id y67sm3278585pfb.71.2021.02.10.13.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 13:13:13 -0800 (PST)
Date:   Wed, 10 Feb 2021 13:13:07 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Woodhouse, David" <dwmw@amazon.co.uk>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH 5/5] KVM: x86/xen: Explicitly pad struct compat_vcpu_info
 to 64 bytes
Message-ID: <YCRMY17WEdpJYd3C@google.com>
References: <20210210182609.435200-1-seanjc@google.com>
 <20210210182609.435200-6-seanjc@google.com>
 <8752a59b694671d25308d644cba661c4ec128094.camel@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8752a59b694671d25308d644cba661c4ec128094.camel@amazon.co.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021, Woodhouse, David wrote:
> On Wed, 2021-02-10 at 10:26 -0800, Sean Christopherson wrote:
> So it isn't clear the additionally padding really buys us anything; if
> we play this game without knowing the ABI we'd be screwed anyway. But
> it doesn't hurt.

Ya, this is purely for folks reading the code and wondering how 62==64.
