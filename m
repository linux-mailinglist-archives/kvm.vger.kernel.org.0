Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB03F94FC
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbhH0HUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhH0HUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:20:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1D3C061757;
        Fri, 27 Aug 2021 00:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZQ3CU43IWogsKyG+uqc1TCqPH8QEEhdztK1oMhkx3lw=; b=UEWQ5QT1Y91/ArLjsjiq9W9wMI
        4duU1mRjJn7JeeiAF847EnVYvfwy4Rfpdir+x9o7riPAQa7etq+VNF8POzrhtbCqJR9z1sDHo+02+
        HbRjsvwxweLsyjOac0MdoWbdd7InTqsNF0dlSuTIm9XrvQy3b/4YvfSEiVegiut0LsQRQ6jPkb8bY
        IfuvY98Og8QSy5GUJ7lJvsT1gSp6DIN+Jh1ydVw5QcNhrxKH4onHt1u2fN6HncmwxCS76O+WauSkn
        5Gg/ot5B8Psq7tBf27BAosAhcGQs4x7CwCAan6H6s6t6hdJz/pw7lyH6HaF3gC9dwlVv0nm5ojf50
        S3+xyWHg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJW5C-00EFBb-NY; Fri, 27 Aug 2021 07:15:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 915013001CD;
        Fri, 27 Aug 2021 09:15:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 708F32C597E4C; Fri, 27 Aug 2021 09:15:17 +0200 (CEST)
Date:   Fri, 27 Aug 2021 09:15:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH 05/15] perf: Track guest callbacks on a per-CPU basis
Message-ID: <YSiRBQQE7md7ZrNC@hirez.programming.kicks-ass.net>
References: <20210827005718.585190-1-seanjc@google.com>
 <20210827005718.585190-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827005718.585190-6-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 05:57:08PM -0700, Sean Christopherson wrote:
> Use a per-CPU pointer to track perf's guest callbacks so that KVM can set
> the callbacks more precisely and avoid a lurking NULL pointer dereference.

I'm completely failing to see how per-cpu helps anything here...

> On x86, KVM supports being built as a module and thus can be unloaded.
> And because the shared callbacks are referenced from IRQ/NMI context,
> unloading KVM can run concurrently with perf, and thus all of perf's
> checks for a NULL perf_guest_cbs are flawed as perf_guest_cbs could be
> nullified between the check and dereference.

No longer allowing KVM to be a module would be *AWESOME*. I detest how
much we have to export for KVM :/

Still, what stops KVM from doing a coherent unreg? Even the
static_call() proposed in the other patch, unreg can do
static_call_update() + synchronize_rcu() to ensure everybody sees the
updated pointer (would require a quick audit to see all users are with
preempt disabled, but I think your using per-cpu here already imposes
the same).


