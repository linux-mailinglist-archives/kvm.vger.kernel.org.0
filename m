Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A0038F639
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhEXX0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXX0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:26:18 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D6DC061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:24:49 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t21so15418770plo.2
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Lggqj9rwmWU4dmI/M08o4O1esiGWtlJC4V6NYrGpyg=;
        b=kpV2ionz8K+r1bwZzeW+XeSiJ43hhEVktNZFyNROyJsKAojv3frL0/FaRw1GSuSxfq
         xIhCTpAWI4FimL+zEIlGjnAScFOIoHZXi8blcX6q7Uie8MzCkxocTcQqZRFO8cbN/prz
         T8ibg54yS6vg1aWxNJRV169Ce2FSTpx5UyW8comOaIXf8mEDO2VKRXkjrh2hcPoFoCAS
         6wJ8/uOlycMq0t4+bDnQGaotAd4OoI4YzRULGpegKoLXo+FZ3ClAYLuYeTfz+sVOJxs3
         plbNsg4BO9kZxRsJki/DwjAwQVGqktabJe0iIcy8iqefG3lKtBaROMn0VGvtKy5fj0kn
         Yr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Lggqj9rwmWU4dmI/M08o4O1esiGWtlJC4V6NYrGpyg=;
        b=pVRDgjOuYextOdAqlbSOpr6kggd0DzoZHKtuvpv0ehkHDR8bZEqxn9V7FBGl87690r
         /SLBTLQ/MvlFEXjJyd6BLbxbebMbq6m6AYbCmz8kv59Ee3zappjNh/s3cifGqn+I1/6p
         Z+dGS7WDuIqw7iU0tvXCs3qY3FtB9vp2/vzg/AYQNBV6HmRxmn1alw3ldUxBmmK3Up/v
         PVNiIoAZmxHDPV6DgsGr2CmIW4yOUbGj3XMQ6f8Y71hnyP4SM9yTNVRJwN/bDua8I6pS
         wUwXArypAq0x6K8knzojNj/Kfwc3KAKgP/HzF7h7Y0H+YAyVz/W+m1uvUFU4aZGG2BXT
         pNOw==
X-Gm-Message-State: AOAM530tYmJcUbRQv1sNnNVSZnFCH3rArqA/ZaBBPUa0/l1AjrBrSuRH
        hmjpx2SpqguFdteR0AOgaSWRUQ==
X-Google-Smtp-Source: ABdhPJzYIoVR9YJdYH4yKp1GneLJJB70x2Rn9xLox0Xci9juHDF6BfP6BlvdgrjvgDKP44IYeW5gaA==
X-Received: by 2002:a17:90a:7f85:: with SMTP id m5mr27579926pjl.128.1621898688361;
        Mon, 24 May 2021 16:24:48 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b124sm11834474pfa.27.2021.05.24.16.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:24:47 -0700 (PDT)
Date:   Mon, 24 May 2021 23:24:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when
 kvm_check_nested_events fails
Message-ID: <YKw1vEzfWG0dPhNM@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-3-jmattson@google.com>
 <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com>
 <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
 <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com>
 <YKwydQlAXHeockLx@google.com>
 <CALMp9eRQXwpM8N6BzrY+gt0cPCCxYuf2UVgdgxjEN6=SrgTkjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRQXwpM8N6BzrY+gt0cPCCxYuf2UVgdgxjEN6=SrgTkjg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Jim Mattson wrote:
> On Mon, May 24, 2021 at 4:10 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, May 24, 2021, Paolo Bonzini wrote:
> > > On 24/05/21 18:39, Jim Mattson wrote:
> > > > Without this patch, the accompanying selftest never wakes up from HLT
> > > > in L2. If you can get the selftest to work without this patch, feel
> > > > free to drop it.
> > >
> > > Ok, that's a pretty good reason.  I'll try to debug it.
> >
> > I don't think there's any debug necessary, the hack of unconditionally calling
> > kvm_check_nested_events() in kvm_vcpu_running() ...
> 
> We don't unconditionally call kvm_check_nested_events() in
> kvm_vcpu_running(). We still call kvm_check_nested_events() only when
> is_guest_mode(vcpu). The only change introduced in this patch is that
> we stop ignoring the result.

Doh, sorry, bad use of "unconditionally".  I meant "unconditionally when in L2". :-)
