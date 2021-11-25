Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B1845E1AB
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350602AbhKYUkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:40:12 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54652 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242104AbhKYUiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:38:12 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637872499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/kowRQz/X1emYsPJm380BhD45fBrknAHK9ZvzfZLhJ4=;
        b=TxPcFNdJN8ZJ1cb4d5pPjpJNd+sPqfcJljRzYDywq8JAOpjxCAmjY6VTW78zhKb7e8zPDI
        JFGfI5pZ5kaiRoLA6S5k8D7MTg/57ZYOd731LTf/jvv2aLgVab0k1Yn3lEHdL9BHoJJ0nb
        fDFpxJhNMS/h+eBeeV8G2a2BrdrU+TsPYRwxFJNGUqr4ARCqiJCWBejm+BCRKkPRbr0TMr
        AQzhzYuyo9TdauSmJ7JYxs9hgvaMdhFZabfnLuoAA8Oa2C8mMm4uw5lckVDQNqLJUbt/yT
        xHQCejkwQKXsm262CcC/0QN5OwBAiQvAy3S4QBDEvhbV0/s4lq3FoLTwx8/8Rw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637872499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/kowRQz/X1emYsPJm380BhD45fBrknAHK9ZvzfZLhJ4=;
        b=s/JyHzL9+1IjI0h7h2P7EN0krBhwFHpNUHQkCXIV/9Rs5DrSeMhpk/pyhKpMYyi+DOAhXZ
        I19dsvLWWXYv7JCA==
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
        Chao Gao <chao.gao@intel.com>
Subject: Re: [RFC PATCH v3 53/59] KVM: x86: Add a helper function to restore
 4 host MSRs on exit to user space
In-Reply-To: <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:34:59 +0100
Message-ID: <878rxcht3g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Chao Gao <chao.gao@intel.com>

> $Subject: KVM: x86: Add a helper function to restore 4 host MSRs on exit to user space

Which user space are you talking about? This subject line is misleading
at best. The unconditional reset is happening when a TDX VM exits
because the SEAM firmware enforces this to prevent unformation leaks.

It also does not matter whether this are four or ten MSR. Fact is that
the SEAM firmware is buggy because it does not save/restore those MSRs.

So the proper subject line is:

   KVM: x86: Add infrastructure to handle MSR corruption by broken TDX firmware 

> The TDX module unconditionally reset 4 host MSRs (MSR_SYSCALL_MASK,
> MSR_START, MSR_LSTAR, MSR_TSC_AUX) to architectural INIT state on exit from
> TDX VM to KVM.  KVM needs to save their values before TD enter and restore
> them on exit to userspace.
>
> Reuse current kvm_user_return mechanism and introduce a function to update
> cached values and register the user return notifier in this new function.
>
> The later patch will use the helper function to save/restore 4 host
> MSRs.

'The later patch ...' is useless information. Of course there will be a
later patch to make use of this which is implied by 'Add infrastructure
...'. Can we please get rid of these useless phrases which have no value
at patch submission time and are even more confusing once the pile is
merged?

Thanks,

        tglx
