Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2ECB4040C1
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbhIHVyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbhIHVyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 17:54:15 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DE5C061757
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 14:53:07 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1so2655734pjv.3
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 14:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MqqsPBvieTQhidpJKG4u8REiYHJcaq8C3VDa8kH77tw=;
        b=VPmCuItGiahDNlB9yXk9EzPj1Y3N8W6jBRskBxas7V8kA9C4vBcJJFeMG7EexZSzwy
         kWYbAKmLcVF1T2e4zxsLX8nNX5EkU5kDicH8De/Scn684Kl9lmzbLDmG1PSiQNrWZ4sd
         GPXKmKzgoLSlIqr1Kt73pj4iZnL2/MmPkxdir3pHpmpXJbZjq2PMkq2HKDp2GfYzyod8
         1Fe3D0i+GnnlyjgMkpp1BVmj8IOxWjqCzbNXJMcybWugg++OMFWx1/QpUlR47yPYtV1H
         BogQhUbYsNy/2OPUnlbyjmCtf9DmgkUJ5ljRXJErlc40ztIkyFa7Spn0MAPVbvMcGjpf
         8fuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MqqsPBvieTQhidpJKG4u8REiYHJcaq8C3VDa8kH77tw=;
        b=1XsdRlsTuacmZu+ZPyGivJJ2lA5f9FFxZeQNqW0Jxnsu/54CYDO64qXAiXJvrgEyY0
         W7GIt4NKV44H61GzWrlma10cxgFNQws05AhQYwoN5DqreSJKdQdRKnnnjhpwUApFGGqO
         bjkPy5NfVf6CX01+2x1pna3N+EpWTlHuWj6rYYEtNDHMwe/MMs+fQngrP7Yd6nu7eVJ+
         NBr9deACE9Y5cXQ2x/uPbsBCh1aEUt/em7mB/BgWCf+q5rIgYyv+9ddaBxw/8328vwTK
         /ce+ozl4Fns5mcWU/O4+xDauMb7C0x17zNHtN1WXUTHXlw86RuoJ+1o3IKOWh1dMYqzp
         VW2w==
X-Gm-Message-State: AOAM533dGLVCPSUPv2PPvlzOFQEh8d3phTzoMtyr9Y5hPl1G8UtZ507G
        Vnao3MtdBWL/8usCnl24R+n1LQ==
X-Google-Smtp-Source: ABdhPJxfMK7bMUjhRglnL31dhaWWFN6MWNDizOAPzBesjPMz4wM5vnAL2NE2ROggoRQdifCTWBjAdg==
X-Received: by 2002:a17:90a:9285:: with SMTP id n5mr338826pjo.29.1631137986562;
        Wed, 08 Sep 2021 14:53:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x64sm148036pfd.194.2021.09.08.14.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 14:53:05 -0700 (PDT)
Date:   Wed, 8 Sep 2021 21:53:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Filter out all unsupported controls when
 eVMCS was activated
Message-ID: <YTkwvrMl7SSCtQF7@google.com>
References: <20210907163530.110066-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907163530.110066-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021, Vitaly Kuznetsov wrote:
> Let's be bold this time and instead of playing whack-a-mole just filter out
> all unsupported controls from VMX MSRs.

Out of curiosity, why didn't we do this from the get-go?
