Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB04245E35A
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 00:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349802AbhKYXcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 18:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbhKYXaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 18:30:01 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34E7C061746;
        Thu, 25 Nov 2021 15:26:49 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637882806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vgq5skJTX/6/sq81x1RW2i2oyLrDBMG7QPZ0Xgtvo8g=;
        b=B8d/NgEaDkGtNhkfe6SDNC6g7knsoiOZDkMZh4nZABvtu4nieq7Zy+owCM0Ko/hxY2Jfpv
        QX1DugP8cJoJF18nXZyvNWvVVs6bXpepZCoaY5WSlsAdrzvNt18GFkkXG9t3mil1+kmfWs
        0lD8x4757GxI4Biq5Em2TENKQMAvYf4845t2lUALwpGuCKaFzJV9jW59Pl6KF2ANHZ0mlx
        fviDJg3q/3AYkwruewbozVfQllV29KS4qvqrnX1nTHNIBUTrMa4CL5Bh1+Z4NFSFRlVikV
        KhvjIpU8Ly4S+3EOu0dV8n5q04SAmVmPzFOz142Jkg0AgUcY+ju3+Nx/nh4SVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637882806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vgq5skJTX/6/sq81x1RW2i2oyLrDBMG7QPZ0Xgtvo8g=;
        b=x9d4qESqqWdbrJtqqtF25qAUgKUY8OdxJilFQX7j46b+/mRNA7b1QzLTNShm/ySIVDpZFS
        fnqes3kACJ6gIsCw==
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 54/59] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
In-Reply-To: <741df444-5cd0-2049-f93a-c2521e4f426d@redhat.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <5ba3573c8b82fcbdc3f3994f6d4d2a3c40445be9.1637799475.git.isaku.yamahata@intel.com>
 <875ysghrp8.ffs@tglx> <741df444-5cd0-2049-f93a-c2521e4f426d@redhat.com>
Date:   Fri, 26 Nov 2021 00:26:45 +0100
Message-ID: <87tufzhl56.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Thu, Nov 25 2021 at 23:13, Paolo Bonzini wrote:
> On 11/25/21 22:05, Thomas Gleixner wrote:
> If there are some patches that are actually independent, go ahead and 
> submit them early.  But more practically, for the bulk of the changes 
> what you need to do is:
>
> 1) incorporate into patch 55 a version of tdx.c that essentially does 
> KVM_BUG_ON or WARN_ON for each function.  Temporarily keep the same huge 
> patch that adds the remaining 2000 lines of tdx.c

There is absolutely no reason to populate anything upfront at all.

Why?

Simply because that whole muck cannot work until all pieces are in place.

That's the classic PoC vs. usable code situation. I.e. you know what
needs to be done from a PoC point of view and you have to get there by
building up the infrastructure piece by piece.

So why would you provide:

handle_A(...) { BUG(); }
..
handle_Z(...) { BUG(); }

with all the invocations in the common emulation dispatcher:

  handle_stuff(reason)
  {
        switch(reason) {
        case A: return handle_A();
        ...
        case Z: return handle_Z();
        default: BUG();
        }
  };

in the first place instead of providing:

 1)
        handle_stuff(reason)
        {
                switch(reason) {
                default: BUG();
                };
        }

 2)
        handle_A(...)
        {
                return do_something_understandable()
        }
        
        handle_stuff(reason)
        {
                switch(reason) {
                case A: return handle_A();
                default: BUG();
        }

 $Z)
        handle_Z(...)
        {
                return do_something_understandable()
        }
        
        handle_stuff(reason)
        {
                switch(reason) {
                case A: return handle_A();
                ...
                case Z: return handle_Z();
                default: BUG();
        }

where each of (1..$Z) is a single patch doing exactly _ONE_ thing at a
time and if there is some extra magic required like an additional export
for handle_Y() then this export patch is either part of the patch
dealing with $Y or just before that.

In both scenarious you cannot boot a TDX guest until you reached $Z, but
in the gradual one you and the reviewers have the pleasure of looking at
one thing at a time.

No?

Thanks,

        tglx
