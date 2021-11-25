Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC4945E116
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350954AbhKYTpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:45:36 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54126 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241825AbhKYTnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:43:35 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637869223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oNGQe95EQ7hQEUgQPmTe+bLWKhHOU6/yuzoxO9TXM9M=;
        b=t+8LHKcNAq6WrDG2wYhMmRjinTpETY+/bW0Nd8tI88NxFBx+XQeoHoRRs0R7WBWe/Q6DCQ
        xYnUFlf8XaqfcH6nTKpyoVk5ICSGlqSlgoVvCJ1SS0lrdy9ZLM9cdXyDxjYwH3yhjYv9ku
        eApDxVAeKYt2hV8MZNwF0dxdeyIfdTSsp8P119HjYcwAqHH3rGoOL4LTBtWXp5mi/C/WJ+
        D0ftl+mRG0Ci9uQQuCUymzuyOEYmaOjcHAO0gvXnyZrze7nIhSaPwm0ZKkPfOIUflpd1a2
        cPMyVQ/yycOHXN4j+bL5E49XjCmyjYIcDFyot01ejJ624w33F3t87v2JeUVLlQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637869223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oNGQe95EQ7hQEUgQPmTe+bLWKhHOU6/yuzoxO9TXM9M=;
        b=6KKR353DSxDNlHyMRzBmnQ7V5oMjDCl+aPKLuY/jLBeLY1c+YfZxICIiDbLZLokHLFy+0l
        7zF5SQaq3DpkFACA==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>
Subject: Re: [RFC PATCH v3 18/59] KVM: x86: Add flag to mark TSC as
 immutable (for TDX)
In-Reply-To: <00772535f09b2bf98e6bc7008e81c6ffb381ed84.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <00772535f09b2bf98e6bc7008e81c6ffb381ed84.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:40:22 +0100
Message-ID: <87ilwgja6x.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> The TSC for TDX1 guests is fixed at TD creation time.  Add tsc_immutable

What's a TDX1 guest?

> to reflect that the TSC of the guest cannot be changed in any way, and
> use it to short circuit all paths that lead to one of the myriad TSC
> adjustment flows.

I can kinda see the reason for this being valuable on it's own, but in
general why does TDX need a gazillion flags to disable tons of different
things if _ALL_ these flags are going to be set by for TDX guests
anyway?

Seperate flags make only sense when they have a value on their own,
i.e. are useful for things outside of TDX. If not they are just useless
ballast.

Thanks,

        tglx
