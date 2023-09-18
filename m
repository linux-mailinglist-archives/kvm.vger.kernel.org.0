Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18267A4F21
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjIRQee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjIRQeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:34:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D23935A4
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:18:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8191a1d5acso4818688276.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695053927; x=1695658727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZvS99EWpYmV17M0NSko9WqctxYlYuXyq70tnlvztC+8=;
        b=kYWDl+xx4ExID7GIVIM28xWcUfQRbW5GPqyYEdSQFrFXuVspV+LDEtOO0kJX/ePZSu
         d0oCy6r2uvZ/FZ7R4sF7ZZPrbCTw3nVJpnUnzifcZZ2YPGlCwBcmzZERlotOsGJcyuC7
         vulykCALkO3luQVH0ACVS6OppPQuVwoVb4ziwC280ZpoHn9Bk9N//U2ylLjv9dIUcUsy
         z/SqvLOwPYQcoGvbVu3w8UcBHjTWP8QaYjBQPWslAwPYU84iblG6j56VGr6YgLXEQGzv
         SXblqbXl3mpF9+vQASAuK2Ezuojfmd0mAfXjbqNbeJ11bCAQvmxtqBFoPGGUWdpODCKp
         HBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053927; x=1695658727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZvS99EWpYmV17M0NSko9WqctxYlYuXyq70tnlvztC+8=;
        b=nqX2njyI2GwbXkjyHZ/8jle0MzxGqcfNleNyGk1CW2znA2gOMCtjGEuavoXGAFbuM8
         xqPMP+YO498iTpGF+ZTebIkHGmttXd2aDcf37S9ocnaN1efoqtGICByqKb/2VdhZrUoe
         Q3CLPVt3huVHFPU99Sw/WRI9/cH+e7HvetWQQFmqZT33o7AhsiP/QAIf7vL3Ku+JsBfm
         gKTgHI+MeEqwYK9aCD/aUn/YXVxpB+gSTxmtXCl5Tw7sPkka+41Y/JwzSOckw+B/jB6+
         wmrHHkMplOGdOxe5L4hRWx7zp5yl7nEowwWBFAE5MTeYHbVafk5WVzm0J7Zr06lpPheQ
         HWxQ==
X-Gm-Message-State: AOJu0Yxy6FeIoyp3RsYd0lfnbRsEoKf8ngB5yYX2QqMtaPQnFj+W5/k+
        DVy9ms9N/sFefd0umyc/Ht/Ng5/51V8=
X-Google-Smtp-Source: AGHT+IHcVvCtL6WyluVysv7d2Ed169XdkSydmgpHMeucYSuDHuEYt28PzhyEcsdcjT4u9kZmeV1jwIRZGJU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:987:b0:d77:8641:670c with SMTP id
 bv7-20020a056902098700b00d778641670cmr202504ybb.10.1695053927815; Mon, 18 Sep
 2023 09:18:47 -0700 (PDT)
Date:   Mon, 18 Sep 2023 09:18:46 -0700
In-Reply-To: <20230918144111.641369-1-paul@xen.org>
Mime-Version: 1.0
References: <20230918144111.641369-1-paul@xen.org>
Message-ID: <ZQh4Zi5Rj3RP9Niw@google.com>
Subject: Re: [PATCH v3 00/13] KVM: xen: update shared_info and vcpu_info handling
From:   Sean Christopherson <seanjc@google.com>
To:     Paul Durrant <paul@xen.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> Currently we treat the shared_info page as guest memory and the VMM informs
> KVM of its location using a GFN. However it is not guest memory as such;
> it's an overlay page. So we pointlessly invalidate and re-cache a mapping
> to the *same page* of memory every time the guest requests that shared_info
> be mapped into its address space. Let's avoid doing that by modifying the
> pfncache code to allow activation using a fixed userspace HVA as well as
> a GPA.
> 
> Also, if the guest does not hypercall to explicitly set a pointer to a
> vcpu_info in its own memory, the default vcpu_info embedded in the
> shared_info page should be used. At the moment the VMM has to set up a
> pointer to the structure explicitly (again treating it like it's in
> guest memory, despite being in an overlay page). Let's also avoid the
> need for that. We already have a cached mapping for the shared_info
> page so just use that directly by default.

1. Please Cc me on *all* patches if you Cc me on one patch.  I belive this is
   the preference of the vast majority of maintainers/reviewers/contributors.
   Having to go spelunking to find the rest of a series is annoying.

2. Wait a reasonable amount of time between posting versions.  1 hour is not
   reasonable.  At an *absolute minimum*, wait 1 business day.

3. In the cover letter, summarize what's changed between versions.  Lack of a
   summary exacerbates the problems from #1 and #2, e.g. I have a big pile of
   mails scattered across my mailboxes, and I am effectively forced to find and
   read them all if I want to have any clue as to why I have a 12 patch series
   on version 3 in less than two business days.

P.S. I very much appreciate that y'all are doing review publicly, thank you!
