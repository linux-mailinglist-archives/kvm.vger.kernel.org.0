Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16CC2F75C5
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 10:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbhAOJrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 04:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbhAOJrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 04:47:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3537C061757;
        Fri, 15 Jan 2021 01:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u+9qKbdLTbihydxXPBHhixLKpJmqcDJjB4iyY7fOB4E=; b=GsRJs85DDYl2xoYosCony1sBvg
        kb6wMsVR6Wnti22lY65CdS7GCc3gOHJUlXhdeh0Zk3BgDlR5pk0cB9HckmpXt+pR/4DzETBuWJRq1
        XwbZZktqPvjrNsdcm+FEBmB6ZNJqP24MA0DHUhYCOfgJJJw3JD00eEerWuTb6t6dfEzO+pNJsUFDt
        ac46mYSLaGFxg2IHWHovmYsWBpxTQlKKBNC6Vsfl5ewh5+Xcs/W90AQeHlK6SoeNKizatklsZE0jU
        HNlgR2cGqC+ZHCWqDoAamG7t/bMByGtD3u8cVrP0y3lajvdtg4OcT1fSfz6JJBULCtxmsWnPMD3FP
        rGUTVR+w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l0Lfy-008kAX-EL; Fri, 15 Jan 2021 09:46:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CF5E3305CC3;
        Fri, 15 Jan 2021 10:45:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A9A0620B5D691; Fri, 15 Jan 2021 10:45:49 +0100 (CET)
Date:   Fri, 15 Jan 2021 10:45:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jason Baron <jbaron@akamai.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: x86: use static calls to reduce kvm_x86_ops
 overhead
Message-ID: <YAFkTSnSut1h/jWt@hirez.programming.kicks-ass.net>
References: <cover.1610680941.git.jbaron@akamai.com>
 <e057bf1b8a7ad15652df6eeba3f907ae758d3399.1610680941.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e057bf1b8a7ad15652df6eeba3f907ae758d3399.1610680941.git.jbaron@akamai.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 10:27:56PM -0500, Jason Baron wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5060922..9d4492b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1350,7 +1350,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
>  static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
>  {
>  	if (kvm_x86_ops.tlb_remote_flush &&
> -	    !kvm_x86_ops.tlb_remote_flush(kvm))
> +	    !static_call(kvm_x86_tlb_remote_flush)(kvm))
>  		return 0;
>  	else
>  		return -ENOTSUPP;

Would you be able to use something like this?

  https://lkml.kernel.org/r/20201110101307.GO2651@hirez.programming.kicks-ass.net

we could also add __static_call_return1(), if that would help.
